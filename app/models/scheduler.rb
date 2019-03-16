class Scheduler < ActiveRecord::Base
  audited
  acts_as_paranoid

  belongs_to :lovedone
  belongs_to :employee

  scope :existing_schedules, ->(id, lovedone_id, start_time, end_time, exclude_ids) {where("(employee_id = ? OR lovedone_id = ?) AND id NOT IN(?) AND ((start_time < ? AND end_time > ?) OR (start_time >= ? AND start_time < ?) OR (end_time > ? AND end_time <= ?))", id, lovedone_id, (exclude_ids.join(',').blank? ? '0' : exclude_ids.join(',')), start_time, end_time, start_time, end_time, start_time, end_time)}
  # scope :existing_lovedone_schedules, ->(id, start_time, end_time, exclude_ids) {where("lovedone_id = ? AND id NOT IN(?) AND ((start_time < ? AND end_time > ?) OR (start_time >= ? AND start_time < ?) OR (end_time > ? AND end_time <= ?))", id, (exclude_ids.join(',').blank? ? '0' : exclude_ids.join(',')), start_time, end_time, start_time, end_time, start_time, end_time)}
  scope :present_day_schedules, ->(id, date, exclude_ids) { where("DATE_FORMAT(start_time,'%m-%d-%Y') = ? AND employee_id = ? AND id NOT IN(?) ", date, id, (exclude_ids.join(',').blank? ? '0' : exclude_ids.join(',')))}
  scope :preceding_schedule, ->(datetime) { where("start_time < ?", datetime).order('`schedulers`.`start_time` DESC').first}
  scope :following_schedule, ->(datetime) { where("end_time > ?", datetime).order('`schedulers`.`start_time` DESC').last}

  after_create :add_appointment_job
  after_update :update_appointment_job
  before_destroy :delete_appointment_job

  def employee
    Employee.unscoped { super }
  end

  def lovedone
    Lovedone.unscoped { super }
  end

  def add_appointment_job
    threshold = self.employee.company.late_notice_notification.time_threshold
    time = TimeDifference.between(Time.zone.now, (self.start_time + (threshold).minutes)).in_minutes
    job = AppointmentsWorker.perform_in(time.minutes, self.id)
    self.update_column(:job_id, job)
  end

  def update_appointment_job
    if self.start_time_changed? and self.end_time_changed?
      job = Sidekiq::ScheduledSet.new.find_job(self.job_id)
      threshold = self.employee.company.late_notice_notification.time_threshold
      time = TimeDifference.between(Time.zone.now, (self.start_time + (threshold).minutes)).in_minutes
      job.reschedule(Time.zone.now + time.minutes)
    end
  end

  def delete_appointment_job
    if self.present?
      job = Sidekiq::ScheduledSet.new.find_job(self.job_id)
      job.delete
    end
  end

  def self.create_schedule(id, emp, lo, s_dt, e_dt, freq, key)
    if id.present?
      @schedule = Scheduler.find(id)
    else
      @schedule = Scheduler.new
    end
    @schedule.employee_id = emp
    @schedule.lovedone_id = lo
    p @schedule.start_time = Time.zone.local_to_utc(DateTime.parse(s_dt))
    p @schedule.end_time = Time.zone.local_to_utc(DateTime.parse(e_dt))
    @schedule.frequency = freq
    @schedule.key = key
    @schedule.save
  end

  def self.schedule_distance_calculation(start_lat, start_lng, end_lat, end_lng)
    url = URI.parse('https://maps.googleapis.com/maps/api/distancematrix/json?origins='+start_lat.to_s+','+start_lng.to_s+'&destinations='+end_lat.to_s+','+end_lng.to_s+'&mode=driving&language=en-EN&'+Rails.application.secrets.gmap_api_key)
    req = Net::HTTP::Get.new(url.request_uri)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == "https")
    res = http.request(req)
    result = JSON.parse(res.body)

    result = result['rows'][0]['elements']
    if result[0]['status'] != "ZERO_RESULTS"
      time = ((result[0]["duration"]["value"])/60).round
      return time
    else
      return time=0
    end
  end

  def self.schedule_datetime(datetime)
    date = datetime.split(' ').first.split('/')
    time = datetime.split(' ').second
    date_time = "#{date.second}/#{date.first}/#{date.third} #{time}"
    final_date_time = Time.zone.local_to_utc(DateTime.parse(date_time))
    return date_time, final_date_time
  end

  def self.day_addition(datetime)
    if datetime.is_a?(Array)
      local_datetime = datetime.second
    else
      local_datetime = datetime
    end
    week_day = (DateTime.parse(Scheduler.schedule_datetime(local_datetime).first) + 1.day).wday
    c_datetime = (DateTime.parse(Scheduler.schedule_datetime(local_datetime).first) + 1.day).strftime('%m/%d/%Y %H:%M')
    return week_day, c_datetime
  end

  def self.frequency_key
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    string = (0...50).map { o[rand(o.length)] }.join
  end

end

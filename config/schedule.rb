set :output, "log/cron_log.log"

every '15 5 1 * *' do
  rake "monthly_bill_calculation:create_monthly_bill"
end
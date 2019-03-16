class LobService
  # require 'lob'
  @lob = Lob.load(api_key: Rails.application.secrets.lob_test_key)
  # @lob = Lob.load(api_key: Rails.application.secrets.lob_live_key)

  def self.create_letter(person, document, provider, start_date, end_date)
    letter_id = if person.class.eql? Lovedone
      lovedone = person
      follower = Follower.new
    elsif person.class.eql? Follower
      lovedone = person.lovedone
      follower = person
    end
      letter_id = @lob.letters.create(
        description: "#{person.first_name} #{person.last_name} Letter",
        to: {
            name: "#{person.first_name} #{person.last_name}",
            address_line1: person.street,
            address_city: person.city,
            address_state: person.state,
            address_country: "US",
            address_zip: person.zip_code.to_s
        },
        from: {
            name: provider.business_name,
            address_line1: provider.address,
            address_city: provider.city,
            address_state: provider.state,
            address_country: "US",
            address_zip: provider.zip
        },
        file: SchedulersHelper.find_letter_template(person.class, person, start_date, end_date),
        data: {
            business_name: provider.business_name, business_address: provider.address, business_city: provider.city, business_state: provider.state, business_zip: provider.zip, business_phone: provider.mobile_phone_number,
            lovedone_first_last: lovedone.full_name, lovedone_first: lovedone.first_name.strip, lovedone_address: lovedone.street, lovedone_city: lovedone.city, lovedone_state: lovedone.state, lovedone_zip: lovedone.zip_code,
            follower_first_last: follower.full_name, follower_first: follower.first_name.strip, follower_address: follower.street, follower_city: follower.city, follower_state: follower.state, follower_zip: follower.zip_code,
            current_date: Time.now.strftime('%m-%d-%y'), start_date: DateTime.parse(start_date).strftime('%m-%d-%y'), end_date: DateTime.parse(end_date).strftime('%m-%d-%y')
        },
        color: false,
        template: false
    )
    return letter_id
  end

  def create_postcard
    @lob.postcards.create(
        description: "Demo Postcard job",
        to: {
            name: "Harry Zhang",
            address_line1: "123 Test Street",
            address_city: "Mountain View",
            address_state: "CA",
            address_country: "US",
            address_zip: "94041"
        },
        from: {
            name: "Harry Zhang",
            address_line1: "123 Test Avenue",
            address_city: "Seattle",
            address_state: "WA",
            address_country: "US",
            address_zip: "94041"
        },
        front: "<html style='padding: 1in; font-size: 50;'>Front HTML for {{name}}</html>",
        back: "<html style='padding: 1in; font-size: 20;'>Back HTML for {{name}}</html>",
        data: {
            name: "Harry"
        }
    )
  end

  def retrieve_postcard(postcard_id)
    @lob.postcards.find("psc_5c002b86ce47537a")
  end

  def retrieve_letter(letter_id)
    @lob.letters.find("ltr_4868c3b754655f90")
  end

  def create_address
    @lob.addresses.create(
        description: "Harry - Home",
        name: "Harry Zhang",
        company: "Lob",
        email: "harry@lob.com",
        phone: "5555555555",
        address_line1: "123 Test Street",
        address_line2: "Unit 199",
        address_city: "Mountain View",
        address_state: "CA",
        address_country: "US",
        address_zip: "94084"
    )
  end

  def find_address(address_id)
    @lob.addresses.find("adr_fa85158b26c3eb7c")
  end

  def delete_address(address_id)
    @lob.addresses.destroy("adr_43769b47aed248c2")
  end

  def verify_address
    @lob.addresses.verify(
        address_line1:  "185 Berry Street",
        address_city:   "San Francisco",
        address_state:  "CA",
        address_zip:    "94107"
    )
  end
end
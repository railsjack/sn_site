module Devise
  module Strategies
    class EmployeeUser < Base

      def valid?
        params["user"] || params["password"]
      end

      def authenticate!
        # Get username and password
        username = params["user"]["username"]
        password = params["user"]["password"]

        # Try to login
        employee = Employee.find_by_username(username)

        if employee.nil?
          fail!("Employee login failed.")
        else
          if employee.valid_password?(password)
            success!(employee)
          else
            fail!("Invalid Password")
          end
        end
      end
    end
  end
end
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      token = request.params[:token] || request.headers["Authorization"]&.split(" ")&.last
      return reject_unauthorized_connection if token.blank?

      decoded_token = JsonWebToken.decode(token)
      user = User.find_by(id: decoded_token[:user_id]) if decoded_token

      if user
        user
      else
        Rails.logger.info "Unauthorized WebSocket connection (Invalid Token)"
        reject_unauthorized_connection
      end
    rescue => e
      Rails.logger.error "Error decoding token: #{e.message}"
      reject_unauthorized_connection
    end
  end
end

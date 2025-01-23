class JsonWebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base

  # Encode payload into a token
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  # Decode token and return the payload
  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(body)
  rescue
    nil
  end
end
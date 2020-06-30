module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      auth_token = request.params[:token]
    
      if !auth_token
        return reject_unauthorized_connection
      end

      decoded_token = JWT.decode(
        auth_token,
        Rails.application.credentials.jwt_secret,
        true,
        { algorithm: 'HS256' }
      )

      if !decoded_token
        return reject_unauthorized_connection
      end

      current_user = User.find(decoded_token[0]["id"])

      workshop = Workshop
      .where(workshop_token: request.params[:workshop_token])
      .first

      if !workshop
        return reject_unauthorized_connection
      end

      # Make sure member is part of workshop
      workshop_member = WorkshopMember
      .where(
        user_id: current_user.id,
        workshop_id: workshop.id
      )
      .first

      if !workshop_member
        return reject_unauthorized_connection
      end

      return current_user
    end
  end
end

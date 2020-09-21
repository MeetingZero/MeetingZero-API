class WorkshopMailer < ApplicationMailer
  def join_workshop(user, organizer_user, workshop)
    @user = user
    @organizer_user = organizer_user
    @workshop = workshop

    mail(to: user.email, subject: "MeetingZero - Join Workshop")
  end

  def join_workshop_new_user(email, organizer_user, workshop)
    @organizer_user = organizer_user
    @workshop = workshop

    mail(to: email, subject: "MeetingZero - Join Workshop")
  end

  def request_feedback(user, workshop)
    @user = user
    @workshop = workshop

    mail(to: user.email, subject: "MeetingZero - Feedback on Your Workshop")
  end

  def new_workshop_host(user, workshop)
    @user = user
    @workshop = workshop

    mail(to: user.email, subject: "MeetingZero - Your New Workshop")
  end
end

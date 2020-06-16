class Api::V1::MeetingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user

  def create
    ActiveRecord::Base.transaction do
      begin
        new_meeting = Meeting.create(
          host_id: @current_user.id,
          purpose: params[:purpose]
        )

        meeting_stage_keys = []

        if params[:template]
          template = MeetingTemplate
          .where(key: params[:template])
          .first

          template_stages = MeetingTemplateStage
          .where(meeting_template_id: template.id)

          template_stages.each do |template_stage|
            meeting_stage = MeetingStage.find(template_stage.meeting_stage_id)

            meeting_stage_keys.push(meeting_stage.key)
          end
        else
          meeting_stage_keys = params[:meeting_stage_keys]
        end

        meeting_stage_keys.each do |meeting_stage_key|
          meeting_stage = MeetingStage
          .where(key: meeting_stage_key)
          .first

          MeetingStageStep
          .where(meeting_stage_id: meeting_stage.id)
          .each do |meeting_stage_step|
            MeetingDirector
            .create(
              meeting_id: new_meeting.id,
              meeting_stage_id: meeting_stage.id,
              meeting_stage_step_id: meeting_stage_step.id
            )
          end
        end

        return render :json => new_meeting, status: 201
      rescue
        render :json => { error: ["could not create meeting"] }
        raise ActiveRecord::Rollback
      end
    end
  end
end

class WorkshopStageStepReady < ApplicationRecord
  belongs_to :workshop

  def self.get_ready_members(workshop_id, workshop_director_id)
    workshop_members = WorkshopMember
    .where(workshop_id: workshop_id)

    ready_members = workshop_members.map do |wm|
      wm
      .as_json
      .merge!({
        ready_member: WorkshopStageStepReady
        .where(
          workshop_id: workshop_id,
          user_id: wm.user_id,
          workshop_director_id: workshop_director_id
        )
        .first
      })
    end
  end
end

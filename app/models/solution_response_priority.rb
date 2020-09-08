class SolutionResponsePriority < ApplicationRecord
  belongs_to :solution_response

  def assign_assessment_category
    impact_level = self.impact_level
    effort_level = self.effort_level

    if impact_level > 5 && effort_level > 5
      self.assessment_category = "Make a Project"
    elsif impact_level > 5 && effort_level <= 5
      self.assessment_category = "Do Now"
    elsif impact_level <= 5 && effort_level > 5
      self.assessment_category = "Forget for Now"
    elsif impact_level <= 5 && effort_level <= 5
      self.assessment_category = "Make a Task"
    end
  end
end

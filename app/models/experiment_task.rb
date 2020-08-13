class ExperimentTask < ApplicationRecord
  has_many :experiment_task_assignments, dependent: :destroy
end

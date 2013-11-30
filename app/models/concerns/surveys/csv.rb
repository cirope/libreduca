module Surveys::CSV
  extend ActiveSupport::Concern

  module ClassMethods
    def to_csv(teach)
      CSV.generate(col_sep: ';') do |csv|
        teach.contents.each do |content|
          row = [content.to_s]

          row << content.questions.joins(survey: :content).map do |question|
            [
              "[#{question.survey}] #{question}",
              question.text? ?
                question.replies.map { |reply| [reply.response] } :
                question.answers.map { |answer| [answer.to_s, answer.replies.count] }
            ]
          end

          csv << row.flatten
        end
      end
    end
  end

  def to_csv
    CSV.generate(col_sep: ';') do |csv|
      csv << [self.content.to_s]
      csv << [self.to_s]

      self.questions.map do |question|
        csv << ["#{question}"]

        if question.text?
          question.replies.each do |reply|
            csv << [nil, reply.response]
          end
        else
          question.answers.each do |answer|
            csv << [nil, answer.to_s, answer.replies.count]
          end
        end
      end
    end
  end
end

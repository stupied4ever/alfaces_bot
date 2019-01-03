module AlfacesBot
  describe Parser do
    subject(:parser) { Parser.new }

    it "parses schedules in minutes" do
      task = parser.parse('me lembre em 5 minutos de bla bla bla')

      expect(task.task).to eq('bla bla bla')
      expect(task.notify_at).to eq(Time.now + 5.minutes)
    end

    it "parses schedules in hours" do
      task = parser.parse('me lembre em 5 horas de bla bla bla')

      expect(task.task).to eq('bla bla bla')
      expect(task.notify_at).to eq(Time.now + 5.hours)
    end

    it "parses schedules in days" do
      task = parser.parse('me lembre em 5 dias de bla bla bla')

      expect(task.task).to eq('bla bla bla')
      expect(task.notify_at).to eq(Time.now + 5.days)
    end
  end
end


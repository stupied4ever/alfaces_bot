module AlfacesBot
  describe Parser do
    subject(:parser) { Parser.new }

    it "parses commands in minutes" do
      task = parser.parse('me lembre em 5 minutos de bla bla bla')

      expect(task.task).to eq('bla bla bla')
      expect(task.notify_at).to eq(Time.now + 5.minutes)
    end

    it "parses commands in hours" do
      task = parser.parse('me lembre em 5 horas de bla bla bla')

      expect(task.task).to eq('bla bla bla')
      expect(task.notify_at).to eq(Time.now + 5.hours)
    end

    it "parses commands in days" do
      task = parser.parse('me lembre em 5 dias de bla bla bla')

      expect(task.task).to eq('bla bla bla')
      expect(task.notify_at).to eq(Time.now + 5.days)
    end

    it "parses commands with DD/MM HH:MM date" do
      task = parser.parse('me lembre em 13/01 08:20 de bla bla bla')

      expect(task.task).to eq('bla bla bla')
      expect(task.notify_at).to eq(Time.parse("13/01/#{Time.now.year} 08:20"))
    end

    it "parses commands with no time to alert" do
      task = parser.parse('me lembre de fazer cerca para o jardim')

      expect(task.task).to eq('fazer cerca para o jardim')
      expect(task.notify_at).to eq(nil)
    end
  end
end


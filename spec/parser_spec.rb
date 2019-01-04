module AlfacesBot
  class FakeMessage
    attr_accessor :text

    def initialize(text)
      self.text = text
    end
  end

  describe Parser do
    subject(:parser) { Parser.new(memory) }
    let(:memory) { double(:memory) }

    it "parses commands in minutes" do
      task = parser.parse(FakeMessage.new('me lembre em 5 minutos de bla bla bla'))

      expect(task.task).to eq('bla bla bla')
      expect(task.notify_at).to eq(Time.now + 5.minutes)
    end

    it "parses commands in hours" do
      task = parser.parse(FakeMessage.new('me lembre em 5 horas de bla bla bla'))

      expect(task.task).to eq('bla bla bla')
      expect(task.notify_at).to eq(Time.now + 5.hours)
    end

    it "parses commands in days" do
      task = parser.parse(FakeMessage.new('me lembre em 5 dias de bla bla bla'))

      expect(task.task).to eq('bla bla bla')
      expect(task.notify_at).to eq(Time.now + 5.days)
    end

    it "parses commands with DD/MM HH:MM date" do
      task = parser.parse(FakeMessage.new('me lembre em 13/01 08:20 de bla bla bla'))

      expect(task.task).to eq('bla bla bla')
      expect(task.notify_at).to eq(Time.parse("13/01/#{Time.now.year} 08:20"))
    end

    context 'with to-do' do
      it "parses with no time to alert" do
        task = parser.parse(FakeMessage.new('me lembre de fazer cerca para o jardim'))

        expect(task.task).to eq('fazer cerca para o jardim')
        expect(task.notify_at).to eq(nil)
      end
    end

    describe 'to-do list question' do
      context 'when there is nothing to do' do
        before do
          expect(memory).to receive(:to_do_list).and_return([])
        end

        it 'answers with a simple message' do
          message = parser.parse(FakeMessage.new('todos'))

          expect(message).to eq({ text: 'You have nothing to do'})
        end
      end

      context 'when there is something to do' do
        before do
          to_do.save

          expect(memory).to receive(:to_do_list).and_return([to_do])
        end
        let(:to_do) { Task.new(task: 'cerca do jardim', chat_id: 1) }

        it 'answers with all the things we asked bot to remember' do
          message = parser.parse(FakeMessage.new('todos'))

          expect(message).to eq({parse_mode: 'Markdown', text: ' - cerca do jardim'})
        end
      end
    end
  end
end


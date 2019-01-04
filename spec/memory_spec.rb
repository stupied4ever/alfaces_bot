module AlfacesBot

  describe Memory do
    subject(:memory) { Memory.new(chat_id) }
    let(:chat_id) { '11' }

    describe '#to_do_list' do
      before do
        Task.new(task: 'cerca do jardim', chat_id: chat_id).save
      end

      it 'returns all to-do itens we have saved' do
        to_do_list = memory.to_do_list

        expect(to_do_list.count).to eq(1)
        expect(to_do_list.first[:task]).to eq('cerca do jardim')
        expect(to_do_list.first[:notify_at]).to eq(nil)
      end
    end

    describe '#done' do
      let(:task) { Task.new(task: 'cerca do jardim', chat_id: chat_id) }

      before do
        task.save
      end

      it 'mark task as done' do
        to_do_list = memory.to_do_list

        expect{ memory.done(task.id) }.to change{
          memory.to_do_list.to_a.size
        }.from(1).to(0)
      end
    end
  end
end

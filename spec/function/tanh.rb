require 'highbrow/function/tanh'

module Highbrow
  module Function
    describe Tanh do
      describe '#primary' do
        it 'calculates tanh of -1.0' do
          expect(Tanh.new.primary(-1.0)).to be_within(0.01).of(-0.7615941559557649)
        end

        it 'calculates tanh of 0.0' do
          expect(Tanh.new.primary(0.0)).to be_within(0.01).of(0.0)
        end

        it 'calculates tanh of 1.0' do
          expect(Tanh.new.primary(1.0)).to be_within(0.01).of(0.7615941559557649)
        end
      end

      describe '#derivative' do
        # TODO
      end

      describe '#upper_limit' do
        it 'returns upper limit' do
          expect(Tanh.new.upper_limit).to be_within(0.01).of(1.0)
        end
      end

      describe '#lower_limit' do
        it 'returns lower limit' do
          expect(Tanh.new.lower_limit).to be_within(0.01).of(-1.0)
        end
      end

      describe '#flat_spot?' do
        it 'doesnt have flat spot' do
          expect(Tanh.new.flat_spot?).to be(false)
        end
      end
    end
  end
end

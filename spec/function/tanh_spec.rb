require 'highbrow/function/tanh'

module Highbrow
  module Function
    RSpec.describe Tanh do
      tanh = Tanh.new
      tolerance = 0.00001

      describe '#primary' do
        it 'calculates tanh of -1.0' do
          expect(tanh.primary(-1.0)).to be_within(tolerance).of(-0.76159)
        end

        it 'calculates tanh of 0.0' do
          expect(tanh.primary(0.0)).to be_within(tolerance).of(0.0)
        end

        it 'calculates tanh of 1.0' do
          expect(tanh.primary(1.0)).to be_within(tolerance).of(0.76159)
        end
      end

      describe '#derivative' do
        it 'calculates derivatite of tanh of -0.76159' do
          expect(tanh.derivative(-0.76159)).to be_within(tolerance).of(0.41998)
        end

        it 'calculates derivative of tanh of 0.0' do
          expect(tanh.derivative(0.0)).to be_within(tolerance).of(1.0)
        end

        it 'calculates derivative of tanh of 0.76159' do
          expect(tanh.derivative(0.76159)).to be_within(tolerance).of(0.41998)
        end
      end

      describe '#upper_limit' do
        it 'returns upper limit' do
          expect(tanh.upper_limit).to be_within(tolerance).of(1.0)
        end
      end

      describe '#lower_limit' do
        it 'returns lower limit' do
          expect(tanh.lower_limit).to be_within(tolerance).of(-1.0)
        end
      end

      describe '#flat_spot?' do
        it 'doesnt have flat spot' do
          expect(tanh.flat_spot?).to be(false)
        end
      end
    end
  end
end

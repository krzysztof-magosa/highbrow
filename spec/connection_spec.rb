require 'highbrow/connection'

RSpec.describe Highbrow::Connection do
  describe '#initialize' do
    it 'has random weight' do
      source = instance_double('source')
      target = instance_double('target')
      conn = Highbrow::Connection.new source, target

      expect(conn.weight).to be_within(0.5).of(0.0)
    end
  end

  describe '#value' do
    it 'returns source neuron output' do
      source = instance_double('source')
      target = instance_double('target')
      conn = Highbrow::Connection.new source, target

      allow(source).to receive(:output) { 0.7 }
      expect(conn.value).to be_within(0.001).of(0.7)
    end
  end

  describe '#weighed_value' do
    it 'returns weighed source neuron output' do
      source = instance_double('source')
      target = instance_double('target')
      conn = Highbrow::Connection.new source, target
      conn.weight = 1.5

      allow(source).to receive(:output) { 2.0 }
      expect(conn.weighed_value).to be_within(0.001).of(3.0)
    end
  end

  describe '.interconnect' do
    it 'connects two neurons' do
      source = instance_double('source')
      allow(source).to receive(:outputs) { [] }
      target = instance_double('target')
      allow(target).to receive(:inputs) { [] }

      expect(source).to receive(:outputs)
      expect(target).to receive(:inputs)

      conn = Highbrow::Connection.interconnect source, target

      expect(conn.source).to be == source
      expect(conn.target).to be == target
    end
  end
end

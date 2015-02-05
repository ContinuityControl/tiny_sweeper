require 'spec_helper'
require 'tiny_sweeper'

describe 'cleaning fields' do
  class Contract
    attr_accessor :name, :notes

    include CautiousSweeper
    sweep :notes, &:strip
    sweep(:name) { |n| n.upcase }
  end

  it 'leaves some unfortunate method names, maybe?' do
    contract = Contract.new
    original_writers = contract.methods.grep(/^original /).sort
    expect(original_writers).to eq([:"original name=", :"original notes="])
    # NB: we're not saying this is GOOD, we're just noting it.
  end

  it 'strips notes' do
    contract = Contract.new
    contract.notes = ' needs stripping '
    expect(contract.notes).to eq('needs stripping')
  end

  it 'upcases name' do
    contract = Contract.new
    contract.name = 'gonna shout it'
    expect(contract.name).to eq('GONNA SHOUT IT')
  end

  describe 'sweeping up ALL the fields at once' do
    let(:the_contract) {
      Contract.new.tap do |c|
        c.name = '  will be upcased  '
        c.notes = '  will be stripped  '
      end
    }

    it 'can clean itself' do
      the_contract.sweep_up!
      expect(the_contract.name).to eq '  WILL BE UPCASED  '
      expect(the_contract.notes).to eq 'will be stripped'
    end

    it 'can be cleaned from the class' do
      Contract.sweep_up!(the_contract)
      expect(the_contract.name).to eq '  WILL BE UPCASED  '
      expect(the_contract.notes).to eq 'will be stripped'
    end
  end
end

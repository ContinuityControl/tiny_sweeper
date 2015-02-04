require 'spec_helper'
require 'tiny_sweeper'

describe 'cleaning fields' do
  class Contract
    attr_accessor :name, :notes

    extend CautiousSweeper
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
end

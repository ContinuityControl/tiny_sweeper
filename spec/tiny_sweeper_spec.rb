require 'spec_helper'
require 'tiny_sweeper'

describe 'cleaning fields' do
  class Contract
    attr_accessor :name, :notes

    include TinySweeper
    sweep :notes, &:strip
    sweep(:name) { |n| n.upcase }
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

  it "lets nils through without complaint. nil is YOUR job to handle." do
    contract = Contract.new
    expect {
      contract.name = nil
      contract.notes = nil
    }.to_not raise_error
    expect(contract.name).to be_nil
    expect(contract.notes).to be_nil
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

  it 'will bark if you try to re-define a field twice' do
    some_class = Class.new
    some_class.send(:include, TinySweeper)
    some_class.send(:attr_accessor, :name)
    some_class.send(:sweep, :name, &:strip)

    # Now the class is sweeping up name, awesome!
    # What if we try to sweep it AGAIN?

    expect {
      some_class.send(:sweep, :name, &:upcase)
    }.to raise_error
  end

  it "will let you sweep an inherited method" do
    # This just falls out of the design, but it's nice to note.
    class BaseClass
      attr_accessor :name
    end
    class SubClass < BaseClass
      include TinySweeper
    end

    expect { SubClass.send(:sweep, :name, &:strip) }.to_not raise_error

    child = SubClass.new
    child.name = '  Monty  '
    expect(child.name).to eq('Monty')
  end
end

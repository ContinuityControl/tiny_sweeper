RSpec.describe 'cleaning fields' do
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

  it 'will bark if you try to re-define a field twice' do
    some_class = Class.new
    some_class.send(:include, TinySweeper)
    some_class.send(:attr_accessor, :name)
    some_class.send(:sweep, :name, &:strip)

    # Now the class is sweeping up name, awesome!
    # What if we try to sweep it AGAIN?

    expect {
      some_class.send(:sweep, :name, &:upcase)
    }.to raise_error("Don't sweep name twice!")
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

RSpec.describe 'defining the same sweep rule on many fields at once' do
  class Address
    attr_accessor :address1, :address2, :city, :state, :zip
    include TinySweeper
    sweep [:address1, :address2, :city, :state, :zip], &:strip
  end

  it 'can do it' do
    address = Address.new

    address.address1 = ' 12 Elm St '
    address.address2 = ' Apt B '
    address.city     = ' New Haven '
    address.state    = ' CT '
    address.zip      = ' 06510 '

    expect(address.address1).to eq('12 Elm St')
    expect(address.address2).to eq('Apt B')
    expect(address.city    ).to eq('New Haven')
    expect(address.state   ).to eq('CT')
    expect(address.zip     ).to eq('06510')
  end
end

RSpec.describe 'defining sweep rules with built-in brooms' do
  describe 'the simple case' do
    class Sundae
      attr_accessor :ice_cream
      include TinySweeper
      sweep :ice_cream, :blanks_to_nil
    end

    it 'can do it' do
      sundae = Sundae.new
      sundae.ice_cream = ''
      expect(sundae.ice_cream).to be_nil
    end
  end

  describe 'using multiple brooms' do
    it 'calls them all, left-to-right' do
      class Sundae
        attr_accessor :topping
        include TinySweeper
        sweep :topping, :strip, :blanks_to_nil
      end
      sundae = Sundae.new
      sundae.topping = '            '
      expect(sundae.topping).to be_nil
    end
  end

  describe 'using multiple brooms, and a block at the end' do
    it 'calls the brooms, left-to-right, and then the block' do
      class Sundae
        attr_accessor :nuts
        include TinySweeper
        # NB: your block could get passed a nil value.
        sweep(:nuts, :strip, :blanks_to_nil) { |v| v && v.upcase }
      end
      sundae = Sundae.new
      sundae.nuts = '  '
      expect(sundae.nuts).to be_nil
      sundae.nuts = '  walnuts  '
      expect(sundae.nuts).to eq('WALNUTS')
    end
  end

  context "when you name a broom that doesn't exist" do
    it "warns when you define the rule, and raises when you sweep a value" do
      class Milkshake
        attr_accessor :flavor
        include TinySweeper
      end

      expect {
        class Milkshake
          sweep :flavor, :make_more_delicious
        end
      }.to output(/TinySweeper doesn't have.*make_more_delicious/).to_stderr

      milkshake = Milkshake.new
      expect {
        milkshake.flavor = 'cherries jubilee'
      }.to raise_exception(TinySweeper::MissingBroomException)
    end
  end

  describe 'adding a custom broom' do
    it 'lets the broom be used' do
      TinySweeper::Brooms.add(:sanitize_sizes) { |v| v.downcase[0] }
      class Milkshake
        attr_accessor :size
        include TinySweeper
        sweep :size, :sanitize_sizes
      end

      milkshake = Milkshake.new
      milkshake.size = 'LARGE'
      expect(milkshake.size).to eq('l')
    end
  end
end

RSpec.describe 'Using #sweep_up! to sweep up all the fields at once' do
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

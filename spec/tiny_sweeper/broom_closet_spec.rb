RSpec.describe 'the brooms in the BroomCloset' do
  describe 'blanks_to_nil' do
    it 'turns empty strings into nil' do
      expect(TinySweeper::BroomCloset.blanks_to_nil('')).to be_nil
    end
    it 'leaves nil values alone' do
      expect(TinySweeper::BroomCloset.blanks_to_nil(nil)).to be_nil
    end
    it 'leaves whitespace-y strings alone' do
      expect(TinySweeper::BroomCloset.blanks_to_nil(' ')).to eq(' ')
    end
  end

  describe 'strip' do
    it 'strips leading and/or trailing whitespace' do
      expect(TinySweeper::BroomCloset.strip('   hello')).to eq('hello')
      expect(TinySweeper::BroomCloset.strip('hello   ')).to eq('hello')
      expect(TinySweeper::BroomCloset.strip('   hello   ')).to eq('hello')
    end
    it 'leaves nil values alone' do
      expect(TinySweeper::BroomCloset.strip(nil)).to be_nil
    end
  end

  describe 'dumb_quotes' do
    it 'replaces smart quotes with dumb quotes in strings' do
      expect(TinySweeper::BroomCloset.dumb_quotes("abc‘")).to eq(%q{abc'})
      expect(TinySweeper::BroomCloset.dumb_quotes("abc’")).to eq(%q{abc'})
      expect(TinySweeper::BroomCloset.dumb_quotes("abcʼ")).to eq(%q{abc'})
      expect(TinySweeper::BroomCloset.dumb_quotes("abc“")).to eq(%q{abc"})
      expect(TinySweeper::BroomCloset.dumb_quotes("abc”")).to eq(%q{abc"})
      expect(TinySweeper::BroomCloset.dumb_quotes("abcˮ")).to eq(%q{abc"})
    end
    it 'leaves nil values alone' do
      expect(TinySweeper::BroomCloset.dumb_quotes(nil)).to be_nil
    end
  end
end

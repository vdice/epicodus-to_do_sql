require("spec_helper")

describe(List) do
  describe(".all") do
    it("starts off with no lists") do
      expect(List.all()).to(eq([]))
    end
  end

  describe("#name") do
    it('tells you its name') do
      list = List.new({:name => 'Our list', :id => nil})
      expect(list.name()).to(eq('Our list'))
    end
  end

  describe('#save') do
    it("lets you save lists to the database") do
      list = List.new({:name => 'Our list', :id => nil})
      list.save()
      expect(List.all()).to(eq([list]))
    end
  end

  describe("id") do
    it('sets its ID when you save it') do
      list = List.new({:name => 'Our list', :id => nil})
      list.save()
      expect(list.id()).to(be_an_instance_of(Fixnum))
    end
  end

  describe("#==") do
    it("is the same list if it has the same name") do
      list1 = List.new({:name => 'Our list', :id => nil})
      list2 = List.new({:name => 'Our list', :id => nil})
      expect(list1).to(eq(list2))
    end
  end
  
  describe(".find") do
    it("finds the specific list based on the id number") do
      list1 = List.new({:name => 'Our list', :id => nil})
      list1.save()
      expect(List.find(list1.id)).to(eq(list1))
    end
  end
end

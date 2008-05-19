require File.dirname(__FILE__) + '/../../spec_helper'
require 'spec/ultrasphinx/matchers/be_indexed'

class DummyNotIndexed < ActiveRecord::Base; end

describe "not indexed" do
  include Spec::Ultrasphinx::Matchers

  it 'should not be indexed' do
    DummyNotIndexed.should_not be_indexed
  end
  
  it 'should not be indexed using some fields' do
    DummyNotIndexed.should_not be_indexed.using_fields([:field_one, :field_two])
  end
end


class DummyIndexedOne < ActiveRecord::Base
  is_indexed :fields => [:field_one, :field_two]
end

describe "indexed using some fields" do
  include Spec::Ultrasphinx::Matchers
  
  it 'should be indexed' do
    DummyIndexedOne.should be_indexed
  end
  
  it 'should be indexed using that fields' do
    DummyIndexedOne.should be_indexed.using_fields([:field_one, :field_two]) 
  end
  
  it 'should not be indexed using other fields' do
    DummyIndexedOne.should_not be_indexed.using_fields([:field_one, :field_four]) 
  end
  
  it 'should not be delta indexed' do
    DummyIndexedOne.should_not be_indexed.with_delta
  end
  
  it 'should be indexed and without delta (explicit)' do
    DummyIndexedOne.should be_indexed.with_delta(false)
  end
end

class DummyIndexedTwo < ActiveRecord::Base
  is_indexed :fields => :field_one, :delta => true
end

describe "indexed using a field and delta activated (true)" do
  include Spec::Ultrasphinx::Matchers
  
  it 'should be indexed' do
    DummyIndexedTwo.should be_indexed
  end
  
  it 'should be indexed using that field' do
    DummyIndexedTwo.should be_indexed.using_fields(:field_one) 
  end
  
  it 'should be delta indexed using that field' do
    DummyIndexedTwo.should be_indexed.using_fields(:field_one).with_delta
  end
  
  it 'should not be indexed using other field' do
    DummyIndexedTwo.should_not be_indexed.using_fields(:field_four) 
  end
  
  it 'should not be indexed using other fields' do
    DummyIndexedTwo.should_not be_indexed.using_fields([:field_one, :field_four]) 
  end
  
  it 'should be delta indexed and then using that field' do
    DummyIndexedTwo.should be_indexed.with_delta.using_fields(:field_one)
  end
  
  it 'should be not indexed and without delta (explicit)' do
    DummyIndexedTwo.should_not be_indexed.with_delta(false)
  end
end

class DummyIndexedThree < ActiveRecord::Base
  is_indexed :fields => :field_one, :delta => {:field => 'cache_version'}
end

describe "delta indexing with an specific field" do
  include Spec::Ultrasphinx::Matchers
  
  it do
    DummyIndexedThree.should be_indexed.with_delta
  end
  
  it do
    DummyIndexedThree.should be_indexed.with_delta(:field => 'cache_version')
  end
  
  it do
    DummyIndexedThree.should be_indexed.with_delta('field' => :cache_version)
  end
  
  it do
    DummyIndexedThree.should_not be_indexed.with_delta(false)
  end
  
  it do
    DummyIndexedThree.should_not be_indexed.with_delta(:field => 'updated_at')
  end

end


class DummyIndexedRaw < ActiveRecord::Base
  is_indexed
end
describe "indexed raw" do
  include Spec::Ultrasphinx::Matchers
  
  it 'should be indexed' do
    DummyIndexedRaw.should be_indexed
  end
  
  it 'should not be delta indexed' do
    DummyIndexedRaw.should_not be_indexed.with_delta
  end
  
  it 'should not be indexed with any field' do
    DummyIndexedRaw.should_not be_indexed.using_fields(:field_one)
  end
end
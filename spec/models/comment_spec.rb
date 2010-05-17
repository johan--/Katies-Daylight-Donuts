require 'spec_helper'

describe Comment do
  should_belong_to :commentable
end
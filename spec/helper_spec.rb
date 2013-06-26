require 'spec_helper'

describe GitPairs::Helper do
  describe "#add" do

    # pairs_conf = hash from config file (ie content)
    # path_to_conf
    # Create tempfile
    # Load tempfile with content per config file
    # set variables
    # method below
    # afterwards check for change in tempfile
    GitPairs::Commands.add(pairs_conf, path_to_conf, opts[:add])
  end
end

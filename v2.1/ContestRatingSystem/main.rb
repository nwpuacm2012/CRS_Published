# encoding = UTF-8
# version 1.2
# last update 14:37 - 2015-03-14
require_relative "moduleContestantBase"
require_relative "classStudent"
require_relative "classTeam"
require_relative "classContestant"
require_relative "moduleContestCore"
require_relative "moduleContestIO"
require_relative "classContest"

Test = Contest.new(ARGV[0].to_i, ARGV[1].to_s)
Test.Setup()
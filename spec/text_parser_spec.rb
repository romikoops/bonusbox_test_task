require 'spec_helper'

describe "Text parser" do

  describe :merge_tags do
    it "should match single %{asdfasdf}" do
      text = "Du hast fuer deinen Einkauf %{CREDIT:ACHIEVED} Punkte bekommen. Dir fehlen noch %{CREDIT:LEVELUP} um den naechsten %{BADGE:LEVELUP} zu erreichen.\n\n%{BONUSBOX:APP:[$caption=Hier geht es zu deinen Bonusbox Rabatten]}"
      expected_result = "Du hast fuer deinen Einkauf 1234 Punkte bekommen. Dir fehlen noch 15 um den naechsten Silver Badge zu erreichen.\n\n[Hier geht es zu deinen Bonusbox Rabatten](https://fb.bonusbox.me)"
      User.new.merge_tags(text).should == expected_result
    end
  end

end

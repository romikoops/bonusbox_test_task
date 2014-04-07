# Merge tags

Our marketing want's to send emails to our bonusbox users,
whenever they successfully earned additional credits.

The email should have placeholder variable text,
which becomes interpolated with the user's current state.

Your goal is to write the interpolation engine, called merge-tags.

Provide your solution as a pull-request on github.
The branchname should match your github alias.

    class Credits
      def achieved
        1234
      end

      def levelup
         15
      end
    end

    class Badge
      def self.levelup
        "Silver Badge"
      end
    end

    class Bonusbox::App
      attr_accessor :caption
      def initialize(params)
        @caption = params[:caption]
      end

      def to_s
        "[#{caption}](https://fb.bonusbox.me/)"
      end
    end

    class User
      attr_accessor :credits, :facebook, :badge
      def initialize
        @credits  = Credits.new
        @facebook = Facebook.new
        @badge    = Badge.new
      end

      def merge_tags(text)
      end
    end

    # text_parser_spec.rb
    ...
    describe "merge_tags" do
      it "should interpolate" do
        text = "Du hast fuer deinen Einkauf %{CREDITS:ACHIEVED} Punkte bekommen. Dir fehlen noch %{CREDITS:LEVELUP} um den naechsten %{BADGE:LEVELUP} zu erreichen.\n\n%{BONUSBOX:APP:[$caption=Hier geht es zu deinen Bonusbox Rabatten]}"
        User.new.merge_tags(text).should == "Du hast fuer deinen Einkauf 1234 Punkte bekommen. Dir fehlen noch 15 um den naechsten Silver Badge zu erreichen.\n\n%[Hier geht es zu deinen Bonusbox Rabatten](https://fb.bonusbox.me)"
      end
    end

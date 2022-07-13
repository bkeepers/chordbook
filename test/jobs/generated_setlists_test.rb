require "test_helper"

class GeneratedSetlistsTest < ActiveJob::TestCase
  test "updates setlists" do
    songsheets = 101.times.map { |i| create :songsheet, rank: i + 1 }

    GeneratedSetlists.perform_now

    trending = User.app.setlists.find_by!(title: "Trending")
    assert_equal 100, trending.songsheets.count

    # Update order
    old_1 = songsheets.first
    new_1 = songsheets.last

    old_1.update! rank: 101
    new_1.update! rank: 1

    GeneratedSetlists.new.perform

    assert_equal 100, trending.reload.songsheets.count
    assert_equal new_1, trending.songsheets.first
    refute_includes trending.songsheets, old_1
  end

  test "'Trending' includes top 100 songs by rank" do
    songsheets = 101.times.map { |i| create :songsheet, rank: i + 1 }

    GeneratedSetlists.new.perform

    setlist = User.app.setlists.find_by!(title: "Trending")
    assert_equal 100, setlist.songsheets.count
    refute_includes setlist.songsheets, songsheets.last
  end

  test "`What's New` includes recently created songsheets" do
    songsheets = 300.times.map { |i| create :songsheet, rank: i + 1 }
    # High rank but older songsheet
    older = create :songsheet, created_at: 1.week.ago, rank: 0

    GeneratedSetlists.new.perform

    setlist = User.app.setlists.find_by!(title: "What's New")

    assert_includes setlist.songsheets, songsheets[0]
    assert_includes setlist.songsheets, songsheets[99]
    refute_includes setlist.songsheets, older
  end

  test "creates decades setlists" do
    GeneratedSetlists.new.perform

    %w[1940s 1950s 1960s 1970s 1980s 1990s 2000s 2010s].each do |title|
      assert Setlist.find_by!(title: title)
    end
  end
end

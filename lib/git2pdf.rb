#require 'bundler/setup'
require 'open-uri'
require 'json'

class Git2Pdf
  attr_accessor :repos
  attr_accessor :basic_auth

  def initialize(options={})
    @repos = options[:repos] || []
    @basic_auth = options[:basic_auth] || nil
    @org = options[:org] || options[:user] || nil
  end

  def execute
    batch = get_issues
    pdf(batch)
  end

  def get_issues
    batch = []
    self.repos.each do |repo|
      #json = `curl -u#{auth} https://api.github.com/repos/pocketworks/repo/issues?per_page=100 | jq '.[] | {state: .state, milestone: .milestone.title, created_at: .created_at, title: .title, number: .number, labels: [.labels[].name]}'`
      json = open("https://api.github.com/repos/#{@org}/#{repo}/issues?per_page=200&state=open", :http_basic_authentication => basic_auth).read
      hash = JSON.parse(json)

      hash.each do |val|
        labels = val["labels"].collect { |l| l["name"].upcase }.join(', ')
        type = ""
        type = "BUG" if labels =~ /bug/i
        type = "FEATURE" if labels =~ /feature/i
        type = "FEATURE" if labels =~ /enhancement/i
        type = "TASK" if labels =~ /task/i

        milestone = val["milestone"] ? val["milestone"]["title"] : ""

        #labels.include?(['BUG','FEATURE','ENHANCEMENT','QUESTION'])
        hash = {short_title: repo, ref: "#{val["number"]}", long_title: "#{val["title"]}", type: type, due: "", labels: labels, milestone: "#{milestone}"}
        batch << hash
      end
    end
    puts batch[0]
    batch
  end

  def pdf(batch)
    require 'prawn'
    row = 0
    col = 0
    Prawn::Document.generate("issues.pdf", :page_size => "A7", :margin => 0, :page_layout => :landscape) do
      dir = File.dirname(__FILE__)
      font_families.update(
          "Lato" => {:bold => "#{dir}/assets/fonts/Lato-Bold.ttf",
                     :italic => "#{dir}/assets/fonts/Lato-LightItalic.ttf",
                     :bold_italic => "#{dir}/assets/fonts/Lato-BoldItalic.ttf",
                     :normal => "#{dir}/assets/fonts/Lato-Light.ttf"})
      font 'Lato'
      batch = batch.sort { |a, b| a["ref"]<=>b["ref"] and a["project"]<=>b["project"]}
      batch.each do |issue|

        ##
        ## If needed, define a new grid
        ##
        #if row >= 5
        #  start_new_page
        #  row = 0
        #  col = 0
        #end
        #
        #if row == 0
        #  define_grid(:columns => 2, :rows => 4, :gutter => 0)
        #end

        #
        # Load json to use on the first card
        #
        puts issue
        #grid(row,col).bounding_box do
        transparent(0.1) { stroke_bounds }

        #Ref
        font 'Lato', :style => :normal, size: 28
        text_box issue[:ref] || "", :at => [185, 195], :width => 100, :overflow => :shrink_to_fit, :align => :right

        #Short title
        font 'Lato', :style => :bold, size: 20
        text_box issue[:short_title] || "", :at => [10, 190], :width => 190, :overflow => :shrink_to_fit

        # Milestone
        font 'Lato', :style => :normal, size: 12
        text_box issue[:milestone] ? issue[:milestone].upcase : "", :at => [10, 165], :width => 280, :overflow => :shrink_to_fit
        #text_box fields["due"] || "", :at=>[120,20], :width=>60, :overflow=>:shrink_to_fit
        #end

        # Type
        font 'Lato', :style => :bold, size: 16, :color => '#666'
        text_box issue[:type] || "UNKNOWN", :at => [10, 135], :width => 280, :overflow => :shrink_to_fit

        # Long title
        font 'Lato', :style => :normal, size: 16
        text_box issue[:long_title] ? issue[:long_title][0..120] : "NO DESCRIPTION", :at => [10, 115], :width => 280, :overflow => :shrink_to_fit



        # Labels
        font 'Lato', :style => :normal, size: 11
        text_box issue[:labels] || "", :at => [10, 20], :width => 280, :overflow => :shrink_to_fit
        #text_box fields[:due] || "", :at=>[120,20], :width=>60, :overflow=>:shrink_to_fit
        #end

        #if col == 1
        #  row = row + 1
        #  col = 0
        #else
        #  col = col + 1
        #end
        start_new_page
      end
    end
  end
end
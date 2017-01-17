#require 'bundler/setup'
require 'open-uri'
require 'json'

class Git2Pdf
  attr_accessor :repos
  attr_accessor :basic_auth
  attr_accessor :api
  attr_accessor :token

  def initialize(options={})
    @repos = options[:repos] || []
    @basic_auth = options[:basic_auth] || nil
    @org = options[:org] || nil
    @token = options[:token]
    @api = options[:api] || 'https://api.github.com'
    @labels = "&labels=#{options[:labels]}" || ''
    @from_number = options[:from_number] || nil
  end

  def execute
    batch = get_issues
    pdf(batch)
  end

  def get_issues
    puts "token :" + @token
    batch = []
    self.repos.each do |repo|
      #json = `curl -u#{auth} https://api.github.com/repos/pocketworks/repo/issues?per_page=100 | jq '.[] | {state: .state, milestone: .milestone.title, created_at: .created_at, title: .title, number: .number, labels: [.labels[].name]}'`
      json = ""
      if @org
          if @token
            json = open("#{@api}/repos/bbc/hive-ci/issues?per_page=100", "Authorization" => ("token " + @token)).read
          else
            json = open("#{@api}/repos/bbc/hive-ci/issues?per_page=100", :http_basic_authentication => basic_auth).read
          end
      else
          if @token
            json = open("#{@api}/repos/bbc/hive-ci/issues?per_page=100", "Authorization" => ("token " + @token)).read
        # for stuff like bob/stuff
          else
            json = open("#{@api}/repos/bbc/hive-ci/issues?per_page=100", :http_basic_authentication => basic_auth).read
          end
      end

      hash = JSON.parse(json)

      hash.each do |val|
        if @from_number
          if(val["number"].to_i < @from_number.to_i)
            next
          end
        end
        labels = val["labels"].collect { |l| l["name"].upcase }.join(', ')
        type = ""
        type = "BUG" if labels =~ /bug/i #not billable
        type = "FEATURE" if labels =~ /feature/i #billable
        type = "ENHANCEMENT" if labels =~ /enhancement/i #billable
        type = "AMEND" if labels =~ /amend/i #not billable
        type = "TASK" if labels =~ /task/i #not billable

        milestone = val["milestone"] ? val["milestone"]["title"] : ""

        #labels.include?(['BUG','FEATURE','ENHANCEMENT','QUESTION'])
        hash = {short_title: repo, ref: "#{val["number"]}", long_title: "#{val["title"]}", type: type, due: "", labels: labels, milestone: "#{milestone}"}
        batch << hash
      end
    end

    batch
  end

  def pdf(batch)
    require 'prawn'
    row = 0
    col = 0
    margin = 20
    Prawn::Document.generate("issues.pdf", :page_size => "A7", :margin => 0, :page_layout => :landscape) do
      dir = File.expand_path File.dirname(__FILE__)
      font_families.update(
          "Lato" => {:bold => "#{dir}/assets/fonts/Lato-Bold.ttf",
                     :italic => "#{dir}/assets/fonts/Lato-LightItalic.ttf",
                     :bold_italic => "#{dir}/assets/fonts/Lato-BoldItalic.ttf",
                     :normal => "#{dir}/assets/fonts/Lato-Regular.ttf",
                     :light => "#{dir}/assets/fonts/Lato-Light.ttf"})
      font 'Lato'
      batch = batch.sort { |a, b| a["ref"]<=>b["ref"] and a["project"]<=>b["project"] }
      #logo = open("http://www.pocketworks.co.uk/images/logo.png")
      logo = open("#{dir}/assets/images/pocketworks.png")
      fill_color(0,0,0,100)
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
        #puts issue
        #grid(row,col).bounding_box do
        #transparent(0.1) { stroke_bounds }

        y_offset = 195

        #Ref
        font 'Lato', :style => :bold, size: 28
        text_box "##{issue[:ref]}" || "", :at => [185, y_offset], :width => 100, :overflow => :shrink_to_fit, :align => :right

        # image watermark
        image logo, :at=>[240,60], :width=>50

        #Short title
        short_title = issue[:short_title]
        short_title = short_title.split('/')[1] if short_title =~ /\//
        font 'Lato', :style => :bold, size: 20
        text_box short_title, :at => [margin, y_offset], :width => 210-margin, :overflow => :shrink_to_fit

        if issue[:milestone] and issue[:milestone] != ""
          y_offset = y_offset - 30
          # Milestone
          font 'Lato', :style => :light, size: 16
          text_box issue[:milestone].upcase, :at => [margin, y_offset], :width => 280, :overflow => :shrink_to_fit
          #text_box fields["due"] || "", :at=>[120,20], :width=>60, :overflow=>:shrink_to_fit
          y_offset = y_offset + 20
        end
        
        fill_color "EEEEEE"
        fill_color "D0021B" if issue[:type] == "BUG"            
        fill_color "1D8FCE" if issue[:type] == "TASK"            
        fill_color "FBF937" if issue[:type] == "FEATURE"
        fill_color "F5B383" if issue[:type] == "AMEND"
        fill_color "FBF937" if issue[:type] == "ENHANCEMENT"

        if issue[:type] and issue[:type] != ""
          fill{rectangle([0,220], margin-10, 220)}          
        else
          fill{rectangle([0,220], margin-10, 220)}          
        end
        
        fill_color(0,0,0,100)
        
        # if issue[:type] and issue[:type] != ""
#           y_offset = y_offset - 20
#           # Type
#           font 'Lato', :style => :bold, size: 16, :color => '888888'
#           text_box issue[:type], :at => [margin, y_offset], :width => 280-margin, :overflow => :shrink_to_fit
#         end

        if issue[:long_title]
          y_offset = y_offset - 50
          # Long title
          font 'Lato', :style => :light, size: 18
          text_box issue[:long_title] ? issue[:long_title][0..120] : "NO DESCRIPTION", :at => [margin, y_offset], :width => 280-margin, :overflow => :shrink_to_fit
        end

        # Labels
        font 'Lato', :style => :bold, size: 12
        text_box issue[:labels].length == 0 ? "NO LABELS!" : issue[:labels], :at => [margin, 20], :width => 220-margin, :overflow => :shrink_to_fit
        #text_box fields[:due] || "", :at=>[120,20], :width=>60, :overflow=>:shrink_to_fit
        #end

        

        #if col == 1
        #  row = row + 1
        #  col = 0
        #else
        #  col = col + 1
        #end
        start_new_page unless issue == batch[batch.length-1]
      end
    end
    batch.length
  end
end

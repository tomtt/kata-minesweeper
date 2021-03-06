require 'optparse'

class UserInterface
  def initialize(command_line_args)
    cli_args_parser.parse!(command_line_args)
    
    unless @size
      puts cli_args_parser
      exit
    end
  end

  def start
    # Immediately quit: no other functionality required yet.
    print_revealed_board
  end

  private
  
  def cli_args_parser
    OptionParser.new do |opts|
      opts.accept(Array, /\[.*\]/) do |arg|
        eval(arg)
      end
      
      opts.on("--size=[width,height]", :REQUIRED, Array) do |size|
        @size = size
        @mines = []
      end
      
      opts.on("--mines=[[x,y],[x',y'], ... ]", Array) do |mines|
        @mines = mines
      end
    end
  end

  def print_revealed_board
    @size[1].times do |y|
      @size[0].times do |x|
        print render_cell(x,y)
      end
      puts
    end
  end

  def render_cell(x, y)
    if mine_at?(x, y)
      "*"
    else
      count = neighbouring_cells_count(x, y)
      count > 0 ? count.to_s : '.'
    end
  end
  
  def each_neighbour(x, y)
    (-1..1).each do |neigx|
      (-1..1).each do |neigy|
        yield x + neigx + 1, y + neigy + 1
      end
    end
  end
  
  def neighbouring_cells_count(x, y)
    count = 0
    neighbours = []
    each_neighbour(x, y) do |dx, dy|
      # count += 1 if mine_at?(dx, dy)
      neighbours << [dx, dy]
    end
    (neighbours & @mines).size
    # count
  end
  
  def mine_at?(x,y)
    @mines.include?([x+1,y+1])
  end
end
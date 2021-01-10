# 迷路を最短距離でクリアするアルゴリズム作成(地図クラスと探検家クラスで実装)
# 最良探検アルゴリズムを使う
# 迷路の盤面は2次元配列で管理、x座標とy座標で管理
# ゴールに近い距離(最短)を判断する→直線距離(ユークリッド距離)
# 上記は「三平方の定理」で求める c²=a²+b²で求まる！

# 地図クラス

# class Map
#   attr_reader :start_xy, :goal_xy, :field

#   START, GOAL = "S", "G"
#   WALL = "#"

#   def initialize
#     #地図フィールド情報
#     @field = DATA.read.split.map{|r|r.split("")}
#     # 地図の縦横サイズ
#     @h = @field.size
#     @w = @field[0].size
#     # スタート地点・ゴール地点の座標
#     @start_xy = find_xy(START)
#     @goal_xy = find_xy(GOAL)
#   end

#   # 指定の記号を検索して、その座標を返す
#   def find_xy(char)
#     @field.each_with_index do |ar,y|
#       if ar.include?(char) then
#         x = ar.index(char)
#         return [x, y]
#       end
#     end
#   end

#   # 地図の詳細情報を表示する(確認用)
#   def description
#     p "地図の縦横サイズは #{@h} x #{@w} です"
#     p "スタート座標は #{@start_xy} です"
#     p "ゴール座標は #{@goal_xy} です"
#   end

#   # 地図のフィールド情報を表示する(人間が見やすく)
#   def display(route=[])
#     # 経路座標に "*" を表示する
#     route.each do |x, y|
#       @field[y][x] = "*"
#     end
#     p "-" * 30
#     @field.each do |ar|
#       p ar.join
#     end
#   end

#   # 指定の座標が移動可能かどうかを判定する
#   def valid?(x,y)
#     return false if x < 0     # 0より値が小さい(地図外)
#     return false if y < 0     # 同上
#     return false if x >= @w    # 地図のサイズを超えてる場合も移動不可
#     return false if y >= @h      #同上
#     return false if @field[y][x] == WALL    # 壁があっても移動不可
#     return true                             #ここまで引っかからなければtrue
#   end

#   # 指定の座標からゴール座標までの直線距離を算出する(三平方)
#   def distance2goal(x,y)
#     hen1 = (@goal_xy[0] - x).abs ** 2    # 底辺の二乗
#     hen2 = (@goal_xy[1] - y).abs ** 2    # 縦の二乗
#     ans = Math.sqrt( hen1 + hen2 )      # 足してルートで割る(sqrt=Mathのモジュール、引数に計算した数値を入れる)
#     return ans
#   end
# end

# 探検家クラス
# class Explorer

#   def initialize
#     # 地図を手に入れる
#     @map = Map.new
#     @map.description
#     @map.display

#     # スタート地点をメモして訪問先リストに登録する
#     @memo = {
#       @map.start_xy => [
#         0,   # スタート地点からの実歩数
#         0,   # ゴールに近いかどうかの判定
#         true,     # 移動予定か(移動済みならfalse)
#         [nil,nil]    # 移動先座標
#       ]
#     }
#   end

#   # メモからゴールに近い座標を取り出してその座標に移動する(移動済みとしてクローズする)
#   def move
#     # 訪問してない経路だけ抽出、並び替え
#     arr = @memo.select{|_,v|v[2]}.sort_by{|_,v|v[1]}
#     xy = arr.to_h.keys.shift   # 配列をハッシュにしてkeyだけ取り出す(ゴールに一番近いと予想されえる座標を1件だけ取り出す)
#     @memo[xy][2] = false        # 移動済みのチェックする
#     return xy
#   end

#   #       UP   RIGHT   DOWN    LEFT
#   V = [ [0,-1], [1,0], [0,1], [-1,0] ]
#   # 現在の座標(xy)から各方向への座標を割り出す(移動可能かは関係なし)
#   def look_around(xy)
#     x,y = xy
#     next_xy_list = []
#     V.each do |vx,vy|
#       next_x = x + vx
#       next_y = y + vy
#       # 東西南北の座標を計算した結果を配列で格納
#       next_xy_list << [next_x,next_y]
#     end
#     #移動可能な座標だけを抽出する、既にメモしてある座標は除外する
#     next_xy_list.select! do |x,y|
#       @map.valid?(x,y) and !@memo[[x,y]]
#     end
#     return next_xy_list    #抽出結果を返り値に指定
#   end

#   # 指定の座標一覧に対してメモを記録する
#   def take_memo(xy_list, pxy)
#     step = @memo[pxy][0] + 1
#     xy_list.each do |x,y|
#       score = @map.distance2goal(x,y) + step
#       memo = [step, score, true, pxy]
#       @memo[[x,y]] = memo
#     end
#     return @memo
#   end

#   # ゴールしたかどうかを判定する
#   def goal?(xy)
#     return true if xy.nil?
#     return true if xy == @map.goal_xy
#     return false
#   end

#   # 指定の座標からスタート地点までの経路を返す
#   def check_route(xy)
#     route = []
#     until xy == @map.start_xy do
#       route << xy             # 経路を全て格納(逆再生の要領)
#       xy = @memo[xy][3]
#     end
#     route.shift if route[0] == @map.goal_xy  #ゴールとスタートは不要なので除外
#     route.pop if route[-1] == @map.start_xy

#     @map.display(route)    # 地図のメソッドに渡す
#   end
# end

# if __FILE__ == $0 then
#   takashi = Explorer.new
#   xy = takashi.move

#   until takashi.goal?(xy) do
#     next_xy_list = takashi.look_around(xy)
#     takashi.take_memo(next_xy_list,xy)
#     xy = takashi.move
#   end
#   takashi.check_route(xy)
#   p "ゴールしたっぽいよ"
# end

#リアルタイム↓----------------------------------------------------------


# 地図クラス
class Map
  attr_reader :start_xy, :goal_xy, :field
 
  START,GOAL = "S","G"
  WALL = "#"
 
  def initialize
    # 地図フィールド情報
    @field = DATA.read.split.map{|r|r.split("")}
    @field_init = Marshal.load(Marshal.dump(@field))
    # 地図の縦横サイズ
    @h = @field.size
    @w = @field[0].size
    # スタート地点・ゴール地点の座標
    @start_xy = find_xy(START)
    @goal_xy = find_xy(GOAL)
  end
 
  # 指定の記号を検索して、その座標を返す
  def find_xy(char)
    @field.each_with_index do |ar,y|
      if ar.include?(char) then
        x = ar.index(char)
        return [x,y]
      end
    end
  end
 
  # 地図の詳細情報を出力する
  def description
    puts "地図の縦横サイズは #{@h} x #{@w} です"
    puts "スタート座標は #{@start_xy} です"
    puts "ゴール座標は #{@goal_xy} です"
  end
 
  # 地図のフィールド情報を出力する
  def display(route=[],goal=nil)
    @field = Marshal.load(Marshal.dump(@field_init))
 
    # 経路座標に "*" を表示する
    route.each do |x,y|
      @field[y][x] = "\e[32m*\e[0m"
    end
    @field.each do |ar|
      puts ar.join
    end
 
    # 標準出力をフラッシュして書き換える
    if goal.nil? then
      printf "\e[#{@h}A"
      STDOUT.flush
      sleep 0.2
    end
  end
 
  # 指定の座標が移動可能かどうかを判定する
  def valid?(x,y)
    return false if x < 0
    return false if y < 0
    return false if x >= @w
    return false if y >= @h
    return false if @field[y][x] == WALL
    return true
  end
 
  # 指定の座標からゴール座標までの直線距離を算出する
  def distance2goal(x,y)
    hen1 = (@goal_xy[0] - x).abs ** 2
    hen2 = (@goal_xy[1] - y).abs ** 2
    ans = Math.sqrt( hen1 + hen2 )
    return ans
  end
end
 
 
# 探検家クラス
class Explorer
 
  def initialize
    # 地図を手に入れる
    @map = Map.new
 
    # スタート地点をメモして訪問先リストに登録する
    @memo = {
      @map.start_xy => [
        0, # スタート地点からの実歩数
        0, # ゴールに近いかどうかの評価(スコア)
        true, # 移動予定か(移動済みならfalse)
        [nil,nil] # 移動元座標
      ]
    }
  end
 
  # メモからゴールに近い座標をひとつ取り出して
  # その座標に移動する(移動済みとしてクローズする)
  def move
    arr = @memo.select{|_,v|v[2]}.sort_by{|_,v|v[1]}
    xy = arr.to_h.keys.shift
    @memo[xy][2] = false if xy
    return xy
  end
 
  #     UP      RIGHT  DOWN   LEFT
  V = [ [0,-1], [1,0], [0,1], [-1,0] ]
  def look_around(xy)
    x,y = xy
    next_xy_list = []
    V.each do |vx,vy|
      next_x = x + vx
      next_y = y + vy
      next_xy_list << [next_x,next_y]
    end
 
    # 移動可能な座標だけを抽出する
    # すでにメモしてある座標は除外する
    next_xy_list.select! do |x,y|
      @map.valid?(x,y) and !@memo[[x,y]]
    end
 
    return next_xy_list
  end
 
  # 指定の座標一覧に対してメモを記入する
  def take_memo(xy_list, pxy)
    step = @memo[pxy][0] + 1
    xy_list.each do |x,y|
      score = @map.distance2goal(x,y) + step
      memo = [step, score, true, pxy]
      @memo[[x,y]] = memo
    end
    return @memo
  end
 
  # ゴールしたかどうか判定する
  def goal?(xy)
    return true if xy.nil?
    return true if xy == @map.goal_xy
    return false
  end
 
  # 指定の座標からスタート座標までの経路を返す
  def check_route(xy,goal=nil)
    route = []
    until xy == @map.start_xy do
      route << xy
      xy = @memo[xy][3]
    end
    route.shift if route[0] == @map.goal_xy
    route.pop if route[-1] == @map.start_xy
 
    @map.display(route,goal)
  end
end
 
if __FILE__ == $0 then
  takashi = Explorer.new
  xy = takashi.move
 
  until takashi.goal?(xy) do
    next_xy_list = takashi.look_around(xy)
    takashi.take_memo(next_xy_list, xy)
    xy = takashi.move
  takashi.check_route(xy)
  end
  takashi.check_route(xy,true)
  puts "ゴールしたよ!"
end


__END__
S#..#.#.##.#.....
...##......##.#..
.###G.###.###.#..
....###.#..#.....
#.#......#...#...
##..#.##.#..#..#.
##.###...#.#..##.
##....#.#...#...#
##.####.#.#####.#
###.....##..#....
##..#.#.##.#..##.
##.##.........#..
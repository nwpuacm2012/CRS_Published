Rating算法：
针对两个参加比赛的人，互相比较，每次比较都更新一次_drating。

比较法则：
比较排名：高者胜，低者负；根据比较结果选取系数进行计算。

更新系数法则：
将本场的比赛系数按参赛人数分配给各个学生
计算方法如下：ef = Kcef / sz

更新法则：
更新时，将两两同学互相比较，然后每次计算出的增量累加到_drating上即可
增量计算方法如下：
    A: dA = cef * (sA - eA) 
    B: dB = cef * (sB - eB)
最后直接累加即可。

读入数据格式：
学生目前信息 student.txt: account name rating
队伍目前信息 team.txt   : account name membernames
计算比赛信息 contest.txt: rank account

输出数据格式：
赛前队伍积分 CurrentTeam       : name oldrating
赛后结果整理 Result.txt        : rank name oldrating newrating
赛后队伍积分 NewTeamData.txt   : account name oldrating newrating
赛后个人积分 NewStudentData.txt: account name oldrating newrating

调用命令：

例：个人赛，比赛系数为120
> ruby main.rb 120 SRM

例： 组队赛，比赛系数为40
> ruby main.rb 40 TRM
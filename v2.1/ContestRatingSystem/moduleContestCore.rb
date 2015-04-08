# encoding = UTF-8

module ContestCore
	def calc_eA_eB( rA, rB )
		da = (rB - rA) / 400.0; db = -da
		ta = 10.0**da + 1.0; tb = 10.0**db + 1.0
		ea = 1.0 / ta; eb = 1.0 / tb;
		return [ea, eb]
	end

	def calc_sA_sB( a, b )
		if a < b then
			[1.0, 0.0]
		else
			[0.0, 1.0]
		end
	end

	def competition( a, b, sz ) # 修改两人的增量
		eA, eB = calc_eA_eB(a.base.rating.to_i, b.base.rating.to_i)
		sA, sB = calc_sA_sB(a.rank.to_i, b.rank.to_i)
		cef = @Kcef / sz.to_f
		dA = (sA - eA) * cef
		dB = (sB - eB) * cef
		a.add_rating(dA)
		b.add_rating(dB)
	end
	
	def Run()
		# 逐一比较
		sz = @Ranklist.size.to_i
		@Kcef = (@Kcef.to_i + sz * ((sz / 30).floor * 0.1 + 0.8)).ceil.to_i
		@Ranklist.each { |i|
			@Ranklist.each { |j|
				if i.base.isRobot && (j.rank * 2 <= sz) then next
				elsif j.base.isRobot && (i.rank * 2 <= sz) then next
				elsif i == j then next
				else competition(i, j, sz.to_i)
				end
			}
		}
	end
end
local WaveData = {}

local function WaveConstructor(numClone : number, numSpeedy : number, numTank : number, numNormal : number, numMiniBoss : number, numBoss : number)
	table.insert(WaveData, {Clone = numClone, Speedy = numSpeedy, Tank = numTank, Normal = numNormal, MiniBoss = numMiniBoss, Boss = numBoss})
end

WaveConstructor(2, 2, 2, 7, 0, 0)
WaveConstructor(3, 3, 4, 9, 0, 0)
WaveConstructor(5, 4, 6, 12, 1, 0)
WaveConstructor(7, 8, 11, 13, 2, 0)
WaveConstructor(12, 12, 12, 20, 3, 1)
WaveConstructor(15, 14, 15, 25, 5, 0)
WaveConstructor(13, 7, 9, 16, 1, 2)




return WaveData
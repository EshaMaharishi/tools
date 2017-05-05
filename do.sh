# Change filenames.
mv src/mongo/s/mongod_test_fixture.h src/mongo/s/sharding_mongod_test_fixture.h 
mv src/mongo/s/mongod_test_fixture.cpp src/mongo/s/sharding_mongod_test_fixture.cpp 

# Change #includes.
find . -name "*.h" -print0 | xargs -0 sed -i '' -e 's/\/mongod_test_fixture.h/\/sharding_mongod_test_fixture.h/g'
find . -name "*.cpp" -print0 | xargs -0 sed -i '' -e 's/\/mongod_test_fixture.h/\/sharding_mongod_test_fixture.h/g'

# Change SConscripts.
find . -name "SConscript" -print0 | xargs -0 sed -i '' -e 's/\/mongod_test_fixture/\/sharding_mongod_test_fixture/g'

# Change class names.
find . -name "*.cpp" -print0 | xargs -0 sed -i '' -e 's/\/MongodTestFixture/\/ShardingMongodTestFixture/g'
find . -name "*.h" -print0 | xargs -0 sed -i '' -e 's/\/MongodTestFixture/\/ShardingMongodTestFixture/g'



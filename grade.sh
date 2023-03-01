CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar' # Change this to get the path to the junit and hamcrest
FILE='ListExamples' # Change this to change the file to test
TESTFILE='TestListExamples' # Change this to change the tester

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cd student-submission

if [[ -e ${FILE}.java ]]
    then
        echo  ${FILE}'.java found'
else
    echo  ${FILE}'.java not found'
    exit
fi

cp ../$TESTFILE.java ./
cp -r ../lib ./

javac -cp $CPATH *.java 2>error-output.txt
if [[ $? -eq 0 ]]
    then 
        echo 'Compile succeeded.'
else
    echo 'Compile error.'
    cat error-output.txt
    exit
fi    

java -cp $CPATH org.junit.runner.JUnitCore $TESTFILE>output.txt 2>error-output.txt

LINECOUNT=`grep -c '' output.txt`
RESULTLINE=`grep 'Tests run:' output.txt`

if [[ RESULTLINE -eq '' ]] 
    then
        RESULTLINE=`grep 'OK' output.txt`
        TESTSRUN=`echo $RESULTLINE | cut -d'(' -f2 | cut -d' ' -f1`
        FAILURES=0
else
    TESTSRUN=`echo $RESULTLINE | cut -d, -f1 | cut -d' ' -f3`
    FAILURES=`echo $RESULTLINE | cut -d, -f2 | cut -d' ' -f3`
fi

TESTSPASSED=$(($TESTSRUN-$FAILURES))

if [[ FAILURES -eq 0 ]]
    then 
        echo ${TESTSPASSED}'/'${TESTSRUN}' tests passed'.
else 
    echo ${TESTSPASSED}'/'${TESTSRUN}' tests passed'.
    LINES=$(($LINECOUNT-4))
    head -n $LINES output.txt
fi


cd ..

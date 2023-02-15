CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
FILE='ListExamples'

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

cp ../TestListExamples.java ./
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

java -cp $CPATH org.junit.runner.JUnitCore $FILE>output.txt 2>error-output.txt

LINECOUNT=`grep -c '' output.txt`
RESULTLINE=`grep 'Tests run:' output.txt`
TESTSRUN=`echo $RESULTLINE | cut -d, -f1 | cut -d' ' -f3`
FAILURES=`echo $RESULTLINE | cut -d, -f2 | cut -d' ' -f3`
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

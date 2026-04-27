#! /bin/bash
clear
# filling courses.txt
bash courses.bash
courseFile="courses.txt"

function displayCoursesofInst(){
    echo -n "Please Input an Instructor Full Name: "
    read instName
    echo ""
    echo "Courses of $instName :"
    cat "$courseFile" | grep "$instName" | cut -d';' -f1,2 | \
    sed 's/;/ | /g'
    echo ""
}

function courseCountofInsts(){
    echo ""
    echo "Course-Instructor Distribution"
    cat "$courseFile" | cut -d';' -f7 | \
    grep -v "/" | grep -v "\.\.\." | \
    sort -n | uniq -c | sort -n -r 
    echo ""
}

# Display all courses in a given classroom
function displayCoursesinLocation(){
    echo -n "Please Input a Class Name: "
    read locName
    echo ""
    echo "Courses in $locName :"
    cat "$courseFile" | grep "$locName" | cut -d';' -f1,2,5,6,7 | \
    sed 's/;/ | /g'
    echo ""
}

# Display available courses for a given subject
function displayAvailableCourses(){
    echo -n "Please Input a Subject Name: "
    read subject
    echo ""
    echo "Available courses in $subject :"
    cat "$courseFile" | grep "^$subject" | awk -F';' '$4 > 0' | \
    sed 's/;/ | /g'
    echo ""
}

while :
do
    echo ""
    echo "Please select and option:"
    echo "[1] Display courses of an instructor"
    echo "[2] Display course count of instructors"
    echo "[3] Display courses of a classroom"
    echo "[4] Display available courses of subject"
    echo "[5] Exit"
    read userInput
    echo ""
    if [[ "$userInput" == "5" ]]; then
        echo "Goodbye"
        break
    elif [[ "$userInput" == "1" ]]; then
        displayCoursesofInst
    elif [[ "$userInput" == "2" ]]; then
        courseCountofInsts
    elif [[ "$userInput" == "3" ]]; then
        displayCoursesinLocation
    elif [[ "$userInput" == "4" ]]; then
        displayAvailableCourses
    else
        echo "Invalid input. Please try again."
    fi
done

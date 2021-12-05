package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"strconv"
	"strings"
)

type occurrence struct {
	one  int
	zero int
}

func main() {
	events, err := ioutil.ReadFile("input.txt")
	if err != nil {
		log.Fatal(err)
	}

	diagnostics := strings.Split(string(events), "\n")

	fmt.Println(partOne(occurrences(diagnostics)))
	fmt.Println(partTwo(diagnostics))
}

func partOne(occurrences []occurrence) int64 {
	gammaRate, epsilonRate := "", ""

	for _, occurrence := range occurrences {
		if occurrence.zero > occurrence.one {
			gammaRate += "0"; epsilonRate += "1"
		} else {
			gammaRate += "1"; epsilonRate += "0"
		}
	}

	gammaValue, _ := strconv.ParseInt(gammaRate, 2, 64)
	epsilonValue, _ := strconv.ParseInt(epsilonRate, 2, 64)

	return (gammaValue * epsilonValue)
}

func partTwo(diagnostics []string) int64 {
	lessCommon := make([]string, len(diagnostics))
	copy(lessCommon, diagnostics)
	return filterOccurrences(diagnostics, true) * filterOccurrences(lessCommon, false)
}

func filterOccurrences(diagnostics []string, mostCommon bool) int64 {
	mostCommonRate, lessCommonRate, currentDiagnostic := "", "", ""

	filteredDiagnostics := diagnostics

	for occurrenceIndex := 0; occurrenceIndex <= len(occurrences(filteredDiagnostics))-1; occurrenceIndex++ {
		occurrence := occurrences(filteredDiagnostics)[occurrenceIndex]

		if occurrence.zero > occurrence.one {
			mostCommonRate += "0"; lessCommonRate += "1"
		} else {
			mostCommonRate += "1"; lessCommonRate += "0"
		}

		for index := 0; index < len(filteredDiagnostics)-1; index++ {
			diagnostic := filteredDiagnostics[index]

			if (mostCommon && mostCommonRate != diagnostic[:len(mostCommonRate)]) || (!mostCommon && lessCommonRate != diagnostic[:len(mostCommonRate)]) {
				filteredDiagnostics = append(filteredDiagnostics[:index], filteredDiagnostics[index+1:]...)
				index--
			}

			if len(filteredDiagnostics) == 2 {
				currentDiagnostic = filteredDiagnostics[0]
			}
		}
	}

	value, _ := strconv.ParseInt(currentDiagnostic, 2, 64)

	return value
}

func occurrences(diagnostics []string) []occurrence {
	occurrences := make([]occurrence, len(diagnostics[0]))

	for _, diagnostic := range diagnostics {
		if string(diagnostic) == "" {
			continue
		}

		for i := 0; i < len(diagnostics[0]); i++ {
			value, _ := strconv.Atoi(string(diagnostic[i]))
			if value == 0 {
				occurrences[i].zero += 1
			} else {
				occurrences[i].one += 1
			}
		}
	}
	return occurrences
}

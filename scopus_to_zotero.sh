#!/bin/bash
#by bsaldivar.emc2@gmail.com
#
function echoIfNotEmpty()
{
	if [ ! -z ${1} ]
	then
		echo "${1}"
	fi
}

inputF="${1}"
outputF=$(echo "${inputF}" | awk -F '.csv' '{print $1}')
ouputF="${outputF}_RDF.rdf"
echo '<rdf:RDF' > "${ouputF}"

rdfA+=(' xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"')
rdfA+=(' xmlns:z="http://www.zotero.org/namespaces/export#"')
rdfA+=(' xmlns:dcterms="http://purl.org/dc/terms/"')
rdfA+=(' xmlns:prism="http://prismstandard.org/namespaces/1.2/basic/"')
rdfA+=(' xmlns:dc="http://purl.org/dc/elements/1.1/"')
rdfA+=(' xmlns:bib="http://purl.org/net/biblio#"')
rdfA+=(' xmlns:foaf="http://xmlns.com/foaf/0.1/">')

if [ -f "${inputF}" ]
then
	lines=$(cat "${inputF}" | wc -l )
	for ((l=2;l<=${lines};l++))
	do
		lineX=$(sed -n "${l}p" "${inputF}" )
		
		#authorA=($(echo "${lineX}" | awk -F '|' '{print $1}' | sed 's/\"//g' | sed 's/^/"/g' | sed 's/$/"/g' | sed 's/,/" "/g' | sed 's/ /_/g' | sed 's/\n//g' ))
		authorA=($(echo "${lineX}" | awk -F '|' '{print $1}' | sed 's/, /|/g' | sed 's/ /_/g' | sed 's/|/ /g' | sed 's/\n//g' | tr -s '"' | sed 's/^"//g' | sed 's/"$//g' | sed 's/&/&amp;/g' | sed 's/\"/\&quot;/g' ))
		#echo "A: ${authorA[*]}"
		title=$(echo "${lineX}" | awk -F '|' '{print $2}' | sed 's/\n//g' | tr -s '"' | sed 's/^"//g' | sed 's/"$//g' | sed 's/&/&amp;/g' | sed 's/\"/\&quot;/g' )
		year=$(echo "${lineX}" | awk -F '|' '{print $3}' | sed 's/\n//g' | tr -s '"' | sed 's/^"//g' | sed 's/"$//g' | sed 's/&/&amp;/g' | sed 's/\"/\&quot;/g' )
		iJournal=$(echo "${lineX}" | awk -F '|' '{print $4}' | sed 's/\n//g' | tr -s '"' | sed 's/^"//g' | sed 's/"$//g' | sed 's/&/&amp;/g' | sed 's/\"/\&quot;/g' )
		iVolume=$(echo "${lineX}" | awk -F '|' '{print $5}' | sed 's/\n//g' | tr -s '"' | sed 's/^"//g' | sed 's/"$//g' | sed 's/&/&amp;/g' | sed 's/\"/\&quot;/g' )
		iNumber=$(echo "${lineX}" | awk -F '|' '{print $6}' | sed 's/\n//g' | tr -s '"' | sed 's/^"//g' | sed 's/"$//g' | sed 's/&/&amp;/g' | sed 's/\"/\&quot;/g' )
		pageS=$(echo "${lineX}" | awk -F '|' '{print $7}' | sed 's/\n//g' | tr -s '"' | sed 's/^"//g' | sed 's/"$//g' | sed 's/&/&amp;/g' | sed 's/\"/\&quot;/g' )
		pageE=$(echo "${lineX}" | awk -F '|' '{print $8}'| sed 's/\n//g' | tr -s '"' | sed 's/^"//g' | sed 's/"$//g' | sed 's/&/&amp;/g' | sed 's/\"/\&quot;/g' )
		iDOI=$(echo "${lineX}" | awk -F '|' '{print $9}'| sed 's/\n//g' | tr -s '"' | sed 's/^"//g' | sed 's/"$//g' | sed 's/&/&amp;/g' | sed 's/\"/\&quot;/g' | sed 's/</%3C/g;s/>/%3E/g' )
		URL=$(echo "${lineX}" | awk -F '|' '{print $10}'| sed 's/\n//g' | tr -s '"' | sed 's/^"//g' | sed 's/"$//g' | sed 's/&/&amp;/g' | sed 's/\"/\&quot;/g' )
		abstract=$(echo "${lineX}" | awk -F '|' '{print $11}' | sed 's/\n//g' | tr -s '"' | sed 's/^"//g' | sed 's/"$//g' | sed 's/&/&amp;/g' | sed 's/\"/\&quot;/g'  )

		rdfA+=('    <bib:Article rdf:about="'${URL}'">')
		rdfA+=('        <z:itemType>journalArticle</z:itemType>')
		rdfA+=('        <dcterms:isPartOf>')
		rdfA+=('            <bib:Journal>')
		if [ ! -z "${iVolume}" ]
		then
			rdfA+=('                <prism:volume>'"${iVolume}"'</prism:volume>')
		fi
		if [ ! -z "${iNumber}" ]
		then
			rdfA+=('                <prism:number>'"${iNumber}"'</prism:number>')
		fi
		if [ ! -z "${iJournal}" ]
		then
			rdfA+=('                <dc:title>'"${iJournal}"'</dc:title>')
		fi
		if [ ! -z "${iDOI}" ]
		then
			rdfA+=('                <dc:identifier>'"DOI ${iDOI}"'</dc:identifier>')
		fi
		rdfA+=('            </bib:Journal>')
		rdfA+=('        </dcterms:isPartOf>')
		rdfA+=('        <bib:authors>')
		rdfA+=('            <rdf:Seq>')
		for((ai=0;ai<${#authorA[*]};ai++))
		do
			#words=$(echo "${authorA[$ai]}" | sed 's/_/ /g' | wc -w )
			#if [[ ${words} -gt 2 ]]
			#then
				#aSur=$(echo "${authorA[$ai]}" | sed 's/_/ /' | awk -F '_' '{print $1}')
				#aGiven=$(echo "${authorA[$ai]}" | sed 's/_/ /' | awk -F '_' '{print $2}')				
			#else
				#aSur=$(echo "${authorA[$ai]}" | awk -F '_' '{print $1}')
			#	aGiven=$(echo "${authorA[$ai]}" | awk -F '_' '{print $2}')
			#fi
			#sed  -r 's/ ([^ ]*)$/_\1/g
			aSur=$(echo "${authorA[$ai]}" | sed  -r 's/_([^_]*)$/ \1/g' | awk -F ' ' '{print $1}' | sed 's/_/ /g' )
			aGiven=$(echo "${authorA[$ai]}" | sed  -r 's/_([^_]*)$/ \1/g' | awk -F ' ' '{print $2}' | sed 's/_/ /g' )			
			
			#echo "authors: ${authorA[$ai]} | aS: ${aSur} | aG: ${aGiven}"
			rdfA+=('                <rdf:li>')
			rdfA+=('                    <foaf:Person>')
			rdfA+=('                        <foaf:surname>'"${aSur}"'</foaf:surname>')
			if [ ! -z "${aGiven}" ]
			then
				rdfA+=('                        <foaf:givenname>'"${aGiven}"'</foaf:givenname>')
			fi
			rdfA+=('                    </foaf:Person>')
			rdfA+=('                </rdf:li>')
		done            
		rdfA+=('            </rdf:Seq>')
		rdfA+=('        </bib:authors>')
		rdfA+=('        <dc:identifier>')
		rdfA+=('            <dcterms:URI>')
		rdfA+=('                <rdf:value>'"${URL}"'</rdf:value>')
		rdfA+=('            </dcterms:URI>')
		rdfA+=('        </dc:identifier>')
		if [ ! -z "${pageS}" ]
		then
			rdfA+=('        <bib:pages>'"${pageS}"'-'"${pageE}"'</bib:pages>')
		fi
		if [ ! -z "${year}" ]
		then
			rdfA+=('        <dc:date>'"${year}"'</dc:date>')
		fi
		if [ ! -z "${abstract}" ]
		then
			rdfA+=('        <dcterms:abstract>'"${abstract}"'</dcterms:abstract>')
		fi
		if [ ! -z "${title}" ]
		then
			rdfA+=('        <dc:title>'"${title}"'</dc:title>')
		fi
		rdfA+=('    </bib:Article>')
	done
fi
rdfA+=('</rdf:RDF>')

for ((i=0;i<${#rdfA[*]};i++))
do
	echo "${rdfA[$i]}" >> "${ouputF}"
done
echo "Results sent to: ${ouputF}"
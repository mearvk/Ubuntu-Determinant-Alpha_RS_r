#! /usr/bin/env python
# -*- coding: iso-8859-1 -*-
# COPYRIGHT Friedel Wolff 
# LICENCE GPL
################################################################################

import locale
import re
import os 
#from os import *
import os.path

subject_concords = ["ngi", "u", "si", "ni", "u", "ba", "i", "li", "a", "si", "zi", "lu", "bu", "ku"];
relative_prefixes = ["engi", "esi", "eni", "o", "aba", "e", "eli", "a", "esi", "ezi", "olu", "obu", "oku"];
situative_prefixes = ["e", "be"];
concords = subject_concords + relative_prefixes + situative_prefixes
object_concords = ["ngi", "ku", "si", "ni", "m", "ba", "wu", "yi", "li", "wa", "zi", "lu", "bu"]

a_rules = [["a", "Y", "PFX"]] 	#prefixes only applicable to verbs ending on -a
i_rules = [["i", "N", "PFX"]] 	#prefixes only applicable to verbs ending on -i
A_rules = [["A", "Y", "PFX"]] 	#prefixes for almost all positive verbs and 
				#future negatives
V_rules = [["V", "Y", "SFX"]]	#common suffixes for verbs ending on -a
e_rules = [["e", "N", "SFX"]] 	#long form of immediate past tense, etc.
rules = [a_rules, A_rules, V_rules, i_rules]

def illegal_reflexive(subject, object):
	"""Returns whether using the given concords together would result in an 
	illegal reflexive

	Although the object concord will always change to 'zi' if reflexivity 
	is intended, most combinations are actually valid for non-reflexive 
	usage. Example:
		Umama uyamsiza (ubaba). 
	Both subject and object are class 1A nouns, but since since they refer 
	to different entities, the word is valid. Reflexives are not handled 
	explicitly anyware since they are undistinguishable from the case where 
	the object is in the 'zi' class. There are therefore actually only two 
	illegal cases.
	"""
	if subject != object: return False;
	if subject == "ngi": return True;
	if subject == "ni": return True;
	return False;


def add_semivowels(prefix):
	prefix = re.sub(r"([aeiou])a", r"\1wa", prefix)
	#TODO: miskien iya?
	prefix = re.sub(r"([aeiou])i", r"\1yi", prefix)
	prefix = re.sub(r"([aeiou])u", r"\1wu", prefix)
	return prefix

def contract(prefix):
	prefix = re.sub(r"[aeiou]([aeiou])", r"\1", prefix)
	return prefix

def verb_rules(prefix):
	"""Generate the necessary rules to prepend the given prefix to a verb
	
	It receives a string with the already built (complete) prefix and 
	returns a list of lists, with each list presenting one affix rule. The 
	consequence of vowel verbs are taken into account here, and no users of 
	this function need to take vowel verbs into account.
	"""
	changed = []
	#normal verb starting on consonant:
	changed.append(["0", prefix, "[^y]"])
	#monosyllabic verbs: in the dictionary in imperative form, e.g. yidla
	changed.append(["yi", prefix, "yi"])

	#now for the complicated part: verbs starting on vowels. (e.g. yakha)
	if prefix[-1] == 'u':
		#the 'u' always needs to be removed, we need a 'w'
		prefix = prefix[0:-1]
		#if the original prefix ended on 'wu', we don't want to add 
		#another 'w' as this will result in 'ww'
		if len(prefix)>0 and prefix[-1] == 'w': 
			changed.append(["y", prefix, "y[ae]"])
		else:
			changed.append(["y", prefix + 'w', "y[ae]"])
		if len(prefix) == 0: 
			#if prefix == 'u' before 'o' we change to 'w' as above
			changed.append(["y", 'w', "yo"])
		else:
			#(if len(prefix) > 0:)
			#for a prefix ending on 'u' before 'o' we simply 
			#remove the 'u' without adding 'w'
			changed.append(["y", prefix, "yo"])
		return changed
	if prefix[-1] == 'i':
		#if the complete prefix is 'i' before a vowel verb, we can 
		#ignore it, as it is simply the same as the imperative form
		#example: i + enza = yenza
		#
		#otherwise, change 'i' to 'y'
		if len(prefix) > 1: 
			prefix = prefix[0:-1]
			changed.append(["y", prefix, "y[^i]"])
			#changed.append(["y", prefix, "y"])
			#TODO: this just made the "yi", prefix "yi" rule (above) unnecessary
		return changed
	if prefix[-1] == 'a':
		prefix = prefix[0:-1]
		changed.append(["y", prefix, "y[^i]"])
		#changed.append(["y", prefix, "y"])
		#TODO: this just made the "yi", prefix "yi" rule (above) unnecessary
		return changed
	if prefix == "o":
		#Although other prefixes can end on 'o' ('zo' or 'yo'), these
		#are only used with consonant verbs and not with monosyllabics.
		#TODO: verify if others are possible
		#TODO: verify if 'zo' and 'yo' are only used before consonants
		
		return changed
	return changed


#These regular expressions will be used to do search-replace palatalisation. It
#is defined outside the function so that it only needs to be done once. It is 
#crucial that the palatalisations starting on 'm' be listed first. Otherwise 
#the rules for the m-less forms will fire first. Hash signs indicate the more 
#common ones.
palatalisations = []
palatalisations.append([re.compile("mbw"), "njw"])	#
palatalisations.append([re.compile("mpw"), "ntshw"])
palatalisations.append([re.compile("mw"), "nyw"])	#
palatalisations.append([re.compile("bw"), "tshw"])
palatalisations.append([re.compile("bhw"), "jw"])
palatalisations.append([re.compile("phw"), "shw"])	#

def palatalise(str):
	new_str = str
	for palatalisation in palatalisations:
		new_str = palatalisation[0].sub(palatalisation[1], new_str)
	return new_str

def quicksort(list):
	if list == []: return []
	return quicksort([x for x in list[1:] if x[1] < list[0][1]]) + \
		list[0:1] + \
		quicksort([x for x in list[1:] if x[1] >= list[0][1]])


def remove_duplicates(rules):
	rules = [rules[0]] + quicksort(rules[1:])

	before = rules[0]
	for i in rules[1:]:
		if i == before: rules.remove(i)
		before = i
	
	return rules
		

def output_myspell():
	print "# Automatically generated by zu_aff.py"
	print "SET ISO8859-1"
	print "TRY aeinulkhosbgywmztdpfcqrvj-ASJMHxEKBGNPTRLDIZFOUWVYC"
	print
	for rule_set in rules:
		identifier = rule_set[0][0];
		rule_set[0][0] = '';
		affix_type = rule_set[0][2];
		rule_set[0][2] = str(len(rule_set)-1)
		#remember that the first element does not count
		for rule in rule_set:
			print affix_type + " " + identifier + ' ' + rule[0],
			if len(rule[1]) > 0: 
				print rule[1],
			else:
				print "0",
			print rule[2]
		print

################################################################################

for i in concords:
	A_rules.extend(verb_rules(i))
	
	A_rules.extend(verb_rules(i+"nga"))
	A_rules.extend(verb_rules(i+"sa"))
	
	#Future tenses:
	a_rules.extend(verb_rules(i+"zo"))
	a_rules.extend(verb_rules(i+"zoku"))
	a_rules.extend(verb_rules(i+"yo"))
	a_rules.extend(verb_rules(i+"yoku"))

	#-sa- + future tenses:
	a_rules.extend(verb_rules(i+"sazo"))
	a_rules.extend(verb_rules(i+"sazoku"))
	a_rules.extend(verb_rules(i+"sayo"))
	a_rules.extend(verb_rules(i+"sayoku"))

	for j in object_concords:
		if illegal_reflexive(i, j): continue
		A_rules.extend(verb_rules(i+j))
		A_rules.extend(verb_rules(i+"nga"+j))#confusable with negatives
		A_rules.extend(verb_rules(i+"sa"+j))

		#Future tenses:
		a_rules.extend(verb_rules(i+"zo"+j))
		a_rules.extend(verb_rules(i+"zoku"+j))
		a_rules.extend(verb_rules(i+"yo"+j))
		a_rules.extend(verb_rules(i+"yoku"+j))

		#-sa- + future tenses:
		a_rules.extend(verb_rules(i+"sazo"+j))
		a_rules.extend(verb_rules(i+"sazoku"+j))
		a_rules.extend(verb_rules(i+"sayo"+j))
		a_rules.extend(verb_rules(i+"sayoku"+j))

#Mode specific ones:
for i in subject_concords:
	#Indicative:
	a_rules.extend(verb_rules(i+"ya"))
	i_rules.extend(verb_rules(add_semivowels("a"+i)))
	#TODO: be- and se- forms
	#Remote past tense:
	
	#Negative future tenses:
	a_rules.extend(verb_rules(add_semivowels("a"+ i) +"zu"))
	a_rules.extend(verb_rules(add_semivowels("a"+ i) +"zuku"))
	a_rules.extend(verb_rules(add_semivowels("a"+ i) +"yu"))
	a_rules.extend(verb_rules(add_semivowels("a"+ i) +"yuku"))

	#-ka- + negative future tenses:
	a_rules.extend(verb_rules(add_semivowels("a"+ i) +"kazu"))
	a_rules.extend(verb_rules(add_semivowels("a"+ i) +"kazuku"))
	a_rules.extend(verb_rules(add_semivowels("a"+ i) +"kayu"))
	a_rules.extend(verb_rules(add_semivowels("a"+ i) +"kayuku"))

	a_rules.extend(verb_rules(contract(i+"a")))
	
	for j in object_concords:
		if illegal_reflexive(i, j): continue
		#Indicative:
		a_rules.extend(verb_rules(i + "ya" + j))
		#Infinitive
		a_rules.extend(verb_rules("uku" + j))
		a_rules.extend(verb_rules("uku" + j))
		a_rules.extend(verb_rules("uku" + j))
		a_rules.extend(verb_rules("uku" + j))
		
		#Negative future tenses:
		a_rules.extend(verb_rules(add_semivowels("a"+ i) +"zu"+j))
		a_rules.extend(verb_rules(add_semivowels("a"+ i) +"zuku"+j))
		a_rules.extend(verb_rules(add_semivowels("a"+ i) +"yu"+j))
		a_rules.extend(verb_rules(add_semivowels("a"+ i) +"yuku"+j))

		#-ka- + negative future tenses:
		a_rules.extend(verb_rules(add_semivowels("a"+ i) +"kazu"+j))
		a_rules.extend(verb_rules(add_semivowels("a"+ i) +"kazuku"+j))
		a_rules.extend(verb_rules(add_semivowels("a"+ i) +"kayu"+j))
		a_rules.extend(verb_rules(add_semivowels("a"+ i) +"kayuku"+j))

		#TODO: be- and se- forms

		#Remote past tense:
		a_rules.extend(verb_rules(contract(i+"a")+j))


a_rules.extend(verb_rules("loku"))
a_rules.extend(verb_rules("ngoku"))
a_rules.extend(verb_rules("noku"))
#class 1 indicative negative		
i_rules.extend(verb_rules("aka"))
		

#Lines below indicated with hashes will cause incorect imperatives
V_rules.append(['a', 'ela', 'a'])
V_rules.append(['a', 'elani', 'a'])
V_rules.append(['a', 'elaphi', 'a'])	#
V_rules.append(['a', 'eka', 'a'])
V_rules.append(['a', 'ekana', 'a'])
V_rules.append(['a', 'ekani', 'a'])
V_rules.append(['a', 'ekaphi', 'a'])	#
V_rules.append(['a', 'isa', 'a'])
V_rules.append(['a', 'isana', 'a'])
V_rules.append(['a', 'isani', 'a'])
V_rules.append(['a', 'isaphi', 'a'])	#
V_rules.append(['0', 'na', 'a'])
V_rules.append(['0', 'ni', 'a'])
V_rules.append(['0', 'phi', 'a'])	#
V_rules.append(['a', 'wa', '[^w]a'])
#^hierdie kan probleme skep met enkelletergreepwerkwoorde
V_rules.append(['a', 'wani', '[^w]a'])
V_rules.append(['a', 'waphi', '[^w]a'])
#^hierdies kan mos ook saam met negatiewe vorme gebruik word. Soos: Igama alipelwa.


e_rules.append(['e', 'ele', 'e'])
e_rules.append(['e', 'eleni', 'e'])
e_rules.append(['e', 'elephi', 'e'])
e_rules.append(['e', 'elile', 'e'])
e_rules.append(['e', 'ile', 'e'])
e_rules.append(['e', 'ise', 'e'])
e_rules.append(['e', 'ise', 'e'])
e_rules.append(['e', 'iseni', 'e'])
e_rules.append(['e', 'isephi', 'e'])
e_rules.append(['e', 'ephi', 'e'])
e_rules.append(['e', 'iwe', 'e'])
#e_rules.append(['e', 'ile', 'e'])
#remember -ana -> ene, ala -> ele ...?
#not combined, only imperative: V_rules.append(['', 'ni', 'a'])
for i in range(len(rules)):
	rules[i] = remove_duplicates(rules[i])

output_myspell()


function send_topic(src) {
	let href = "byond://?src=" + src + ";update=1";
	let selects = document.getElementsByClassName("part_select");
	for (let i = 0; i < selects.length; i++) {
		const sel = selects[i];
		href += ";" + "parts=" + sel.id;
		href += ";" + "materials=" + sel.value;
	}
	let grade_input = document.getElementById("grade_input");
	if(grade_input)
		grade_input.value = Math.min(6, Math.max(1, grade_input.value))
		href += ";" + "grade=" + grade_input.value;
	window.location = (href);
}

var {spawn} = require('child_process');
var gulp = require('gulp');
var gutil = require('gulp-util');
var os = require('os');
var path = require('path');
var preprocess = require('gulp-preprocess');
var rename = require('gulp-rename');
var temp = require('temp');

/**
* Setup preprocess to work with AutoIt files (.au3)
*/
gulp.task('configure:preprocess', ()=> {
	var ppRules = require('./node_modules/preprocess/lib/regexrules');
	ppRules.au3 = {
		echo: ";[ \t]*@echo[ \t]+(.*?)[ \t]*",
		exec: ";[ \t]*@exec[ \t]+(\\S+)[ \t]*\\((.*)\\)[ \t]*",
		include: "(.*);[ \t]*@include(?!-)[ \t]+(.*?)[ \t]*",
		'include-static': "(.*);[ \t]*@include-static[ \t]+(.*?)[ \t]*",
		if: {
			start: "[ \t]*;[ \t]*@(ifndef|ifdef|if)[ \t]+(.+)(?:[ \t]*\n+)?",
			end: "[ \t]*;[ \t]*@endif(?:[ \t]*\n)?",
		},
	};
});


/**
* Run AutoIt in test mode - compiles a temp file and immediately runs it
*/
gulp.task('test', ['configure:preprocess'], ()=> {
	var tempFile = temp.path({prefix: 'SRA-Helper', suffix: 'au3'});

	return gulp.src('./src/SRA-Helper.au3')
		.pipe(preprocess({context: {BOND: true}}))
		.pipe(rename(path.basename(tempFile)))
		.pipe(gulp.dest(path.dirname(tempFile)))
		.on('end', ()=> {
			gutil.log('Temp file:', tempFile);
			spawn('wine', ['autoit/AutoIt3.exe', tempFile], {
				cwd: `${__dirname}/src`,
			});
		})
})


/**
* Build all available versions
*/
gulp.task('build', ['build:bond', 'build:monash', 'build:qh']);


// Main build pipeline {{{
var build = (name, context) => {
	var tempFile = temp.path({prefix: 'SRA-Helper', suffix: 'au3'});

	var cmd = [
		os.platform == 'linux' ? 'wine' : undefined,
		'autoit\\Aut2Exe\\Aut2exe.exe',
		'/in',
		tempFile,
		'/out',
		`..\\builds\\${name}`,
		'/icon',
		'SRA-Helper.ico',
		'/pack'
	].filter(i => i); // Remove blanks

	return gulp.src('./src/SRA-Helper.au3')
		.pipe(preprocess({context}))
		.pipe(rename(path.basename(tempFile)))
		.pipe(gulp.dest(path.dirname(tempFile)))
		.on('end', ()=> {
			gutil.log('Temp file:', tempFile);
			spawn(cmd.slice(0, 1)[0], cmd.slice(1), {
				cwd: `${__dirname}/src`,
			});
		})
};
// }}}


/**
* Compile SRA-Helper in Bond University mode
*/
gulp.task('build:bond', ['configure:preprocess'], ()=>
	build(name = 'SRA-Helper-Bond.exe', context = {BOND: true})
);


/**
* Compile SRA-Helper in Monash University mode
*/
gulp.task('build:monash', ['configure:preprocess'], ()=>
	build(name = 'SRA-Helper-Monash.exe', context = {MONASH:true})
);

/**
* Compile SRA-Helper in Queensland Health mode
*/
gulp.task('build:qh', ['configure:preprocess'], ()=>
	build(name = 'SRA-Helper-Queensland-Health.exe', context = {QH: true})
); 

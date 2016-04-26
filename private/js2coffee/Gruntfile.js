// This is a configuration file to help you convert all your meteor .js files to .coffee
// Follow this steps:
// 1 - Create a '{PROJECT_ROOT}/private/js2coffee/' folder on your meteor project root.
// 2 - Create a 'package.json' file into '/private/js2coffee/' folder. (grab package.json example on http://gruntjs.com/getting-started)
// 3 - Copy this 'Gruntfile.js' to '/private/js2coffee/'
// 4 - cd into '{PROJECT_ROOT}/private/js2coffee/' and 'npm install grunt-js2coffee --save-dev' on the terminal
// 5 - 'grunt' on the terminal
// 6 - cd into '{PROJECT_ROOT}/private/coffee/'
// 7 - 'cp -r ./ ../../' on the terminal
// 8 - Manually delete all js files that were converted.

module.exports = function (grunt) {

    // This code is expected to
    grunt.initConfig({
        js2coffee: {
            each: {
                options: {},
                files: [
                    {
                        expand: true,
                        cwd: '../../',
                        src: ['both/**/*.js', 'client/**/*.js', 'server/**/*.js'],
                        dest: '../coffee/',
                        ext: '.coffee'
                    }
                ]
            }
        }
    });

    grunt.loadNpmTasks('grunt-js2coffee');
    grunt.registerTask('default', ['js2coffee']);
};
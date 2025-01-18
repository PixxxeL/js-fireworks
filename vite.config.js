import { defineConfig } from 'vite'
import { viteStaticCopy } from 'vite-plugin-static-copy'
import coffee from 'vite-plugin-coffee'
import pugPlugin from 'vite-plugin-pug'


export default defineConfig({
    base: './',
    server: {
        host: '127.0.0.1',
        port: '8080',
        strictPort: true
    },
    build: {
        chunkSizeWarningLimit: 1024 * 1024,
        outDir: './dist',
        minify: 'terser',
        emptyOutDir: true
        //sourcemap: boolean | 'inline' | 'hidden'
    },
    plugins: [
        viteStaticCopy({
            targets: [
                {
                    src: 'assets',
                    dest: '.'
                }
            ]
        }),
        coffee({
            jsx: false
        }),
        pugPlugin({
            pretty: true
        })
    ],
    css: {
        preprocessorOptions: {
            sass: {
                silenceDeprecations: ['legacy-js-api']
            }
        }
    }
})

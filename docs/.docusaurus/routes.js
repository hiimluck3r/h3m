import React from 'react';
import ComponentCreator from '@docusaurus/ComponentCreator';

export default [
  {
    path: '/h3m/__docusaurus/debug',
    component: ComponentCreator('/h3m/__docusaurus/debug', '7bf'),
    exact: true
  },
  {
    path: '/h3m/__docusaurus/debug/config',
    component: ComponentCreator('/h3m/__docusaurus/debug/config', '006'),
    exact: true
  },
  {
    path: '/h3m/__docusaurus/debug/content',
    component: ComponentCreator('/h3m/__docusaurus/debug/content', '800'),
    exact: true
  },
  {
    path: '/h3m/__docusaurus/debug/globalData',
    component: ComponentCreator('/h3m/__docusaurus/debug/globalData', 'c87'),
    exact: true
  },
  {
    path: '/h3m/__docusaurus/debug/metadata',
    component: ComponentCreator('/h3m/__docusaurus/debug/metadata', '33b'),
    exact: true
  },
  {
    path: '/h3m/__docusaurus/debug/registry',
    component: ComponentCreator('/h3m/__docusaurus/debug/registry', '3d7'),
    exact: true
  },
  {
    path: '/h3m/__docusaurus/debug/routes',
    component: ComponentCreator('/h3m/__docusaurus/debug/routes', '6a3'),
    exact: true
  },
  {
    path: '/h3m/markdown-page',
    component: ComponentCreator('/h3m/markdown-page', '6d9'),
    exact: true
  },
  {
    path: '/h3m/docs',
    component: ComponentCreator('/h3m/docs', '93d'),
    routes: [
      {
        path: '/h3m/docs',
        component: ComponentCreator('/h3m/docs', 'a82'),
        routes: [
          {
            path: '/h3m/docs',
            component: ComponentCreator('/h3m/docs', '7c1'),
            routes: [
              {
                path: '/h3m/docs/fluxcd_configuration',
                component: ComponentCreator('/h3m/docs/fluxcd_configuration', '17a'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/h3m/docs/getting_started',
                component: ComponentCreator('/h3m/docs/getting_started', 'ce2'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/h3m/docs/Loadbalancing/cilium_installation',
                component: ComponentCreator('/h3m/docs/Loadbalancing/cilium_installation', 'c30'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/h3m/docs/Loadbalancing/metallb_installation',
                component: ComponentCreator('/h3m/docs/Loadbalancing/metallb_installation', '7c8'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/h3m/docs/proxmox_configuration',
                component: ComponentCreator('/h3m/docs/proxmox_configuration', '7f3'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/h3m/docs/talos_configuration',
                component: ComponentCreator('/h3m/docs/talos_configuration', '6b2'),
                exact: true,
                sidebar: "tutorialSidebar"
              }
            ]
          }
        ]
      }
    ]
  },
  {
    path: '/h3m/',
    component: ComponentCreator('/h3m/', 'aaf'),
    exact: true
  },
  {
    path: '*',
    component: ComponentCreator('*'),
  },
];

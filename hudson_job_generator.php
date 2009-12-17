<?php

class HudsonJobGenerator extends AkelosGenerator
{
    public $command_values = array('destination_path','(array)options');
    
    public function hasCollisions() {
        $this->collisions = array();
        $this->destination_path = rtrim($this->destination_path, DS);
        if(is_dir($this->destination_path)){
            $this->collisions[] = Ak::t('%path already exists', array('%path' => $this->destination_path));
        }
        return count($this->collisions) > 0;
    }

    public function generate() {

        $Installer = new AkInstaller();
        
        $vars['github'] = $Installer->promptUserVar('Github user and project (optional) [user project]', array('optional' => true, 'default' => false));
        
        if(!empty($vars['github'])){
            list($user, $project) = explode(' ', $vars['github'].' ');
            //$vars['git'] = "git@github.com:$user/$project.git";
            $vars['git'] = "git://github.com/$user/$project.git";
            $vars['github'] = "http://github.com/$user/$project/";
        }
        
        if(empty($vars['git'])){
            $vars['git'] = $Installer->promptUserVar('Git repository (git@git.example.com:repository_name.git)');
        }
        
        $vars['email'] = $Installer->promptUserVar('Notification email');
        
        
        foreach ($vars as $k=>$v){
            $this->assignVarToTemplate($k, $v);
        }

        $this->save(
                $this->destination_path.DS.'config.xml', 
                $this->render('config'));

        $this->save(
                $this->destination_path.DS.'nextBuildNumber', 
                $this->render('nextBuildNumber'));

        @mkdir($this->destination_path.DS.'builds');
        @mkdir($this->destination_path.DS.'workspace');
    }
}


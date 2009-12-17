<?php echo "<?"; ?>xml version='1.0' encoding='UTF-8'?>
<project>
  <actions/>
  <description></description>
  <logRotator>
    <daysToKeep>-1</daysToKeep>
    <numToKeep>50</numToKeep>
  </logRotator>
  <keepDependencies>false</keepDependencies>
  <?php if(!empty($github)) : ?>
  <properties>
    <com.coravy.hudson.plugins.github.GithubProjectProperty>
      <projectUrl><?php echo $github; ?></projectUrl>
    </com.coravy.hudson.plugins.github.GithubProjectProperty>
  </properties>
  <?php endif; ?>
  <scm class="hudson.plugins.git.GitSCM">
  <?php if(!empty($git)) : ?>
    <remoteRepositories>
      <org.spearce.jgit.transport.RemoteConfig>
        <string>origin</string>
        <int>5</int>
        <string>fetch</string>
        <string>+refs/heads/*:refs/remotes/origin/*</string>
        <string>receivepack</string>
        <string>git-upload-pack</string>
        <string>uploadpack</string>
        <string>git-upload-pack</string>
        <string>url</string>
        <string><?php echo $git; ?></string>
        <string>tagopt</string>
        <string></string>
      </org.spearce.jgit.transport.RemoteConfig>
    </remoteRepositories>
  <?php endif; ?>
    <branches>
      <hudson.plugins.git.BranchSpec>
        <name>*</name>
      </hudson.plugins.git.BranchSpec>
    </branches>
    <mergeOptions/>
    <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
    <submoduleCfg class="list"/>
  </scm>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers class="vector">
    <hudson.triggers.SCMTrigger>
      <spec>*/5 * * * *</spec>
    </hudson.triggers.SCMTrigger>
  </triggers>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.tasks.Shell>
      <command>./makelos test:units --ci</command>
    </hudson.tasks.Shell>
    <hudson.tasks.Shell>
      <command>./makelos release:generate</command>
    </hudson.tasks.Shell>
  </builders>
  <publishers>
    <hudson.tasks.ArtifactArchiver>
      <artifacts>releases/*</artifacts>
      <latestOnly>false</latestOnly>
    </hudson.tasks.ArtifactArchiver>
    <hudson.tasks.junit.JUnitResultArchiver>
      <testResults>reports/units.xml</testResults>
      <testDataPublishers/>
    </hudson.tasks.junit.JUnitResultArchiver>
    <hudson.tasks.Mailer>
      <recipients><?php echo @$email; ?></recipients>
      <dontNotifyEveryUnstableBuild>false</dontNotifyEveryUnstableBuild>
      <sendToIndividuals>true</sendToIndividuals>
    </hudson.tasks.Mailer>
  </publishers>
  <buildWrappers/>
</project>
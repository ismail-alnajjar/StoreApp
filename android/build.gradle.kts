// -------------------------
// ملف build.gradle.kts
// -------------------------

// إعداد buildscript لإضافة الكلاسات الخاصة بالبلجنات مثل google-services
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // الطريقة الصحيحة لإضافة classpath في Kotlin DSL
        add("classpath", "com.google.gms:google-services:4.4.1")
    }
}

// جميع المشاريع تستخدم هذه المستودعات
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// تغيير مسار مجلد build ليكون خارجي مشترك بين جميع المشاريع
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

// تعيين مجلد build جديد لكل مشروع فرعي
subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

// ضمان أن التقييم لأي subproject يعتمد على مشروع :app
subprojects {
    project.evaluationDependsOn(":app")
}

// تعريف مهمة تنظيف (clean) لجميع ملفات البناء
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

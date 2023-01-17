@ECHO OFF
:: Build website using R build script
R CMD BATCH C:\Users\shkan\OneDrive\Documents\Personal\MC_Group_Pick\shkoeneman.github.io\build_website.R
:: Push to Github using shell script for Git bash
"" "%PROGRAMFILES%\Git\bin\sh.exe" --login -i -c "C:/Users/shkan/OneDrive/Documents/Personal/MC_Group_Pick/shkoeneman.github.io/push_site.sh"
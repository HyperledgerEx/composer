ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.9.2
docker tag hyperledger/composer-playground:0.9.2 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��dY �=�r�Hv�Iew�-g�T�<L塇v���@���Ԁ$H��E�M�l��$D��B�ri?&_��<�)���HU�� )�"��d�3����}����\��tw�P��
+F�4l65yضWoF�=��� � ���X���1�<�=ab�L��3������@?P���k;��ǒ��}3ޢ��(��e�����m����Wh�R ���v�o�/ݑUZg�܃��\����6J�Mhi�نVt�XR�4,��� �w�z�g��A��Z�ރ�3BJ�
���X>K��Y)�~�3 �8�@�	[��9iCס�NZFK�`h�:ZKnX��1XB�F�n�N(9����H�X�O��X����������3z�������lv�Vq�`E;F�G<��b�&IU��9m�=h�� F�3��ՄZ(��T�	Rµ4LL�2��h�/�r�� �i7A�th���TʇZ���&��>��(i�g�Rc��6S��b(򜹼���8&�_�#�a�~n���:�Sf��W3�p�Q��.��Z9l\=����Cj�}�,��#�ĜQ7�^Mr\`A��j��:��S	K�ZE��N�<� ?�A�f���_:t��%R�"���tYI�I�w��R�-��ވ�����-�胷��|"�ߤ�1��?�P:�1\�	���9����9��@�j�SP�s�6���7�?òx���p,G������[<�.�P�hC�;�m��A���4ɟ�ja��~L	���J�VN���W!�2����&�=��{�X~���˃9��yO��?���:`��_6��SV�h;9��A� ��F���q��l�cx�f����m��Z o������@�X!�I�Q���i��Lh�
I��c <����#q �M�� -�Bۮ>��}��i;�t-���	0-�/;�F�r!I�]�cXSN[S�ۤGZ�f��.��^�z�Ji��U:2�5z��P��\�%�?�5�����p�K�Ê�"�qs�;:,kfG��v�c�۱��[��W4<�(!��7́���5ò�t�>!)�v5����c���\�81�u]h�3s��1I�H�*�n_�^���*/Ͱ������pgI���F7|vp��Oд�:p_p��Ǣ\"�9&��HO�H'l��Z h�Q� ��@�ՉS8�]Uӈ��`��C���꺪��?
�Ը��拗�G�:d���h�%L�}I�-�[��� �����W�#	��B�=\����m'���� �lTw5����f��������`�썭�q'G�/Ӭ��Bn�v��(f�hG�|%��l�DU�G�C!cvxM�����-&�+w�*�8@�WA�a�i��}Ƙ���s�2�:^#i�7�2��ʀ08�ZA��ɀ��Gg�Obs0�8w�c��Q���b��#WuH!L{�@?�N��CVb{�C�66Ԡ�AGU:� ���(什��,N�= �C��C �c�^R~EC�:�6��w����kD��E7��������$��������׈S-���y=[���������Ж�i�p���T����Bz0����?q>�l��:`����a�_�������?���?���0�������v�x֙�r �d�iӦ6�,CQ���Yr�3�\��5 ����R��wqBU���Y%]��{C�	�����|ˮ���� _mc����DVnVH���Y],W�R���յ���@���������x8�G.��{~�5�\'�o��Of!b�Ne��JU(WϪRA,ժ7S=�6�v�/l�&�i����D�=�����B�m��N~x��De!��ށ�s��;xnA��oI�qy#����Lq�n����{�51K���1Y����@��-2���BQ_��^�hhzY ���*
}9Jl��W�������wm����"u���k����e����l9�\��1����%8z��뀇���]��g����&D�@8lZ��^��G�	�5�F�������t�6V��L�||��X<�x�CG��X��?�A�����������/�������m���S�E�7t��l@�2��i�����d�iG(������ȝ@��J�uȗ=R��WI��9��v`�!DWs�<#��g,D'3��F�1js�2� L�	2EFM�6ЍP4(�(k�%S/T���0�}�����\�W�Sh��a��<�5F�U�Q� �_,���r�'n���/��w^���,������+�������m���j2	@����^��H� �{���z�b/v�gq.LG�=*��Z����w��,��w�,�p��Ʀ���'6������	��\�����
,��eQ��H��r��i����3<�o����O����4��[�.ay���g�������<����:�������w��<oy|��zD%��"���I��?��R��*��(����	\�2:Ӄ8���fſjg��Pd�c�N�rE�-x��:�V�}�qnl�;u������xu��1� �f�eթ�މ�=>���}���ʤ�+
��(�<�[��h��:���D7�+�#d�[���/(^�a�ϴ��l�?�������m��:�HV_���̹��_�x��^a��%W�ޥax��&
̹�-���X���鳴p&���E!�3{��' Tߤo'K�y�䮩�@
C$e0��)l0%F$��<�� ]*�g��X>2��X��j)#V�t��D�PO2�%�X�su�I�h_�����|�џ`�|)������X�{1U��4,e�Ј�$Hg"�CL�^`F��Ů����,�_ӵ�T=���ʥ|���Φ�4���Y�{���٫��]�QEؚ�w�>�����mB�^*@7��;��g�ohn��7E���iV���5,h����O�Ć������n�<~� �S�5o�W�n�j	7A8L���5 ������["Ԡ�M������?�]�~�@������V����/�n1����^Q@K��(�gq�>���Y,;���n���fX�$����X,���k�����]�?HC~x����Y���W�[�@Gԉ\����Գ%�`��<��/�!rU���؉[B�t�����kn\y앸�ǀe��}.\h��S���������+�?M`���k�{�,�YTH�W/�@��r)����[3\��l̖[8����}.�X�����������cyn��]|���ņ �����;h��І�ˣ��	gp���e��>���?��ů���O�Kl��^ܗ�?���FxKs����j�4��;�� �M��8��R�bΑ5xc��b�v�+/��0fa���ܷ`>z�����Ć�������++��`�E���\"$&Q�z[d�)s�(�E漑2JxC$�ջ�V,|�榇m���h?���-p �&���K�����C�����o��뀕��Z�y�)�\,jcQ�7�ŧ�������|M�Q����?|���_����?O�~���p��i)��pI��hq�N2o5�,�&d�1��s�F2�)2��I�������o��W��~EMW����7�O�ij*�_�!��t�O�}�������6t۰��m��ֿP[#%v�����u9YM���&*
}K���fo�e럿��-j��|���xl�Z�[�z�2�i�����0��~�kX��Ǟ�au�'�Jm�.�c�F���8�����ic��gg矋o�?��=V����VCm���N#d�qTf�cHn���*{�P.�Q���%+�g:5��1d�m썓���"��d�A�D�Ѣ��N��i�$aK�;J�cc0���L+1�Vdf'!'LB��2��	Ԅ:��cH�HԶ���	cH�9��b�*e��PI�{� I��y:-(�0�RB[*E��׋���h*74�&TC�jG�t�D:0N��sZD��Ṛ�nN`jb�SH���R(���:����;���k�޸�x�=j^�R��Q��ʽו^�=a��v�"W�zFU�%����{���i�M٧�����A�p
U�-v����\��~G)�ʠx.���D��{���I=J{����#{�>:�ԏ�r��M�v)Vh�p�ҩ������Ӿ��͓�x\Hy=�(��56�J����?����b���	�0����X�
��\�QrZ�W�7��S4��B.5�5W)pI�-��i��@�hIH�ܝ�����^T�����'�oՓ��sމg�8��oR�z�{\Oh�Z�D>�r���|!q�85��b%!م�a9~ʉ�\{pp^����Cs��mfb*:8�s���<���BJh�¹ �6�USu�AJ��S�M��T�n����A�W��8@�K%�Ng��}��U�c�34�i�n����Ҝ}p�������	�v��$��v��W���Ê~\ԓ�t3ږ�� n�o�M#k��,J�B2�V��o��C�V�i.��7�����^'K^,f�A���*�D�z;��*�5 �����K3��Pc[�f�8򟈞	��0�����F�����;�_tz�o`M�`��O��cX l�u@�N:,Ku���xBR�R)��t�p��N�职m���6MK�|>u`�Ѥ�mğR�%�NW����;ִ���@�|p��n�\iA([��}T+��B�{��ӉW�u��֌W�~Jq�nmxT�|V�|�����v�s��í�X�ʊ���a>�_�a�
��~J�5�l�{�?�<�?7�����_<��w���<�<�?;G�����@P��Ry)T���@���p4v�d�#%s�D91��l�&W�o
�m7j3�M۔{���Qʞf]*n���[ϖ�����仗���t�p��mupA'�M�]�����*�i�{�~?p����KZj;2���`��;����7������a-=)�
�_����2N�A�uьP�p,�a�m8ｯ�|�-Z�`��r�Fx1�p�j����նC 2���*��2Z8�K��K␶AO��6��ƏZ"g��&)@>=������>A�aP�{p7� �'��.�W��n���P!�X���xAjƀ� aQ�A��㟈B��F�0�7lG'�㯝�_ȣ�.����<�Q��o����&ƕ#�'�(��D~��°
�D��������>)����?��9����v��n�����zR��.���"N\�pB $pA �vBHh9�u\����m���ͼyp��̳���U���WU���^��_I�&<�����7Gd�p�V�t��$����+��\��YPE�"����J.��ĥ�8����I
h���D�y�x�����HQ���򹣍��6�1F$�L�U�a������6}�*m��65�$�ղ�
]v����#��u�|����R�c�G?p�P��I�L��_4�:Y�3c����
6@�ۂ�S�r��.4�9h��g���x3���zV��c�{�����h��8v�g��=�:�����H���{Wq�&���X?���S�����Ơ>����K(Ar����(�	�L��&�k�9�=Ài��}A���K0�NW�#�FS(w"�f�����G'�d�Ɩ�-r@�y�6I�Kҗ�g\<�?�C;�^�^7 R��1Q\S��� �Ӄ�F�����%��:ppQKt����@q��ߖ��Rdx��td=�<�kS��+�D�tn
D-Ğ�|�=��� ���7��deN>�G�<qɹ��U�F֊L�5�v-�>R���?9XS��5۷�xK�ccХ�é5E�F��OM�E�Vx��VHɰ�.=פ;7��ځ�N�vz�����ᲡE�DE y�E�ښO7�k�f"��$9⚍#�a;tnlt����L�	+��֭�/sz�~��0=s�br��4����E�偸&�ȷ���E�L�zc �X�N��a��=�wwc���D���*#��I��D����T<Il����h������{����o�~+����~�Ǉ?��9a�����O���>��>����"~�"~�"į����o���
��vd�3)4��/�^"#G%%ދ�J"����q�K�2�t<ދ�TR� ���K$�9	$����R7���'=y�j?Y���g�~f��������|������H��#���x{��5C�A��l݆~�0�{W8��=����7�ׯ���A����[X��#��!��2� c5�(U��ts�ҋ���0Ϛ6��G����g�j���g����"�<| Xu������*�+0�b;�M��i%gG��%��sᬖ�: �-����Fa�]�E��i�X��9]�9{̶[�qg�YHC�/��v���
�M��q�>*��ay܍�gB}`�l�ማ3���yixo�([�7��h�궝Wq����v#�=�֪�A-J%���}~yT\0C�t���&�IX�x��G��*��&;�M]��\�Xk����/s��A��3%_o&a�D�{B.b����H����^�:�AcE��n�	&�~�6k�̢��i�}���uV�s�ZS����S&��7�sp>$:ń�7��Y�?1��h����0E�I�i^�.&ga�yf1m���E�3i=���J��d_ǳ��e�ˣ�T�����L$���hZu:?Jӳ��+sk09�Ǌ����>6����u���k��.�K��K��K��K��K��K��K⮸K⮰K⮨K⮠Kb��
�`�%�l�h�-�7�,��ZEi�����n����T=Ü-�d�܉���hq��D�O��J�BK�ϗ�=wq=J
�[���۹��]���p�ND*�����9�����t��S�il�DK����T�%6�g}��L�Ȓ5��I��Ή����\�;u[�3Փ	5ƶz�Z�z�Cx��E�O�cн�,��G �ir���5�x�賥MuS2��c�ڹ}��)хY<S��)��$jO�	�b2M�΍�-5�-1����,O��R��˅AT��c-��4+�n��#=��^v8K'��Z����ڋ��o};�K;���vBo���ym�m�����%��`7,���ݬ��q��a���E�|8?���]�>���ЎGw�Q��v_ل]J�=���ߦPh�������\V,��G��8)��B?�&x���o���>�����<����%�ٵ�����L+��[�YE45�ʴe.U?Iʽ��ė��s,��|~6���];���H��"n5�yz���M��\�c�j6���˶6-���4=\A�7�(Di��Ȩ]�Y���qc#Hf-�Y�B�YR�Bj��&��츪��jD&Y��fGrfH�+�/���0R�hG�n��%�k��5��i3�k-O�������A�m�D�+��Ic��2h{I��i3j�C�i���F��1-��,��Uk�e��-�C�U�n������T�y�Z���m�F�E����>"��Z.�,����(�A�$/Qb�9SQ9I�'A������A��0Q���#f��Q�>3R�q]���F�V�����7�����~�Z�ɢ@Y��Z����&LK%.]���__^�������{��� ��� ��r�󏄯UL�������3nQf��n�4�Ic�4���+y�N�V�=u'p�F�����/7�Z�����'�S�e1�<�-Sk��Lz�T���8-w��h�Pʥ����՚c����8��K�ձ��N�����_�Gi-{6w�t��>/�����Z�m'P�@9+д}�(���ټA���\Hj���\a>S��t?���9��U�(�<��l�(\p�H�^��� �GݓtU�w��b�5��+6R�"��z�=��+��u*�ʊ�t������Rt�;Z�����A1BE�b��0��e����u�N�E�H+G"�g��xt����aJrĄQ�-��֑v�v�<�ŏ:q�%!ocgB�v	�s&�*�ҙ 8�I��C!�s��J�8�՚�ݣ�x�L�*GTGzk�e&\>2sY��Y����(�����L�]'�D��z�i��1}���4"��O�G��C!<��š����x�gj磥�n��Z�������w�	1 q� nX^ߡ0�~Ik�J�5i>��q����If^�gC"�G
e4���њa�؍y;2C���ܪ-#.������t[�F��+�U�䇥�U��8��wq黡w��[���޼P�6o\Ə�?"�a����F�wCooDM/��/�X����Ds^��v��B�Z�UF��c%�~�-�M��?��󸎆�TBCo����ԇ_~I�}�[q���A�<sm�����̓&�<��1��1�5�9��2z>�>!�/ ���TZW��?D�=�L��O�_ĴY`�@��N0kv�~�������в<QLS1C��.�
�MǇz]:yiܹ�H�\�!^s���s��-��!<�5���y�I�.���}}��+������_��Oz7M�������)���5��wʝ�A�B*��|�����=<L2]t��I��	*>T�9ғvUA<CGվ�~ywg�l�ؼ�}um���J@��|���}�:�
s-C%�.]/Kb>~�Z��^������"�kj�ku��>Iǿni��z�l����&�����/�n8����v�2.����B��D�tFA�G1�0E�����u�6 D�!FW��AE�C�7���q���}#�����.�5qw�	I�i���.�#�,�)�r�iX���/ijy6 ������j[e�&$��������t�'�\��� �<���kt��C���§��=P1�w������e����qj<�L��SE\@��J�y�'3I���6��49ׅ���w���m���ɎO�!uH�m
~�W����96F���C*0�1��G/�'ɭ� 
�m���@?$����2I�U��_'�/�H������ce��ۛ�޽y�|ǙFݾ1A�6,���Gk���������_O�������@21L����/�[=�����t��=������-/dp�����%�o��r(sk��� >Ľ�\ 6o8������L���8\V�+��6�k}��3��D��l�j>	��	�b�[g����cd�*�o�DJ�!�]��(�d�80N���� -���2�0�3���fX��E�=����� 8�S�
��ũ۟o�ýl��5/c��Z��^0D(Olt`2j��n0���ᡶ����b:��C2j�SG�$(�YC77��C�d|���5� �qLcͣ�9)8e���!�k��p[��X�aW~6�zl��ܥ恐#��h	�y
};��YX������J(:�ް�u�"[�L4��nɫ&�v�2qn�f��L��`�8�B[6�7��������	:�ۂ��1�^���~�F�D��
�&@o��Z��b+~��]1$AE�#�#GHO53c��l���X�qRr`��
(�{�� T���!�C�|�����뱉W׆���)t{�u��d�+Kܜ�F^��i��є�	��!�����.�`�M����F�e��k7�#�n7�@���W ��ո����dی�;����Z�y����w�\[�5������o�x���^��8V�O����D%[��pl%�h������Y�j�u�f�|�4K���1����J��-\����oe���b��J��g9�t��WS�u�Oѩ�c嚊������Q�b��@J�2Q$bJ,�K&{ݮң�T� *�����,��^&	���Ipjk�|_`���fŹk����дO>풟n��	{ɧ0� u_r�^l�a́�x1�TH��$)OGR2����F@ �L�3J*�N���dt��AN�3J<�P 	���\t���m��)��oC%����O�� |x�޸C��dv�l��&�0�����[2^����:x��V�,W�����\�.��*�w̕�Ɋ4U/��7D�L�l�k4�Ep��47���7N,T�gx�����u�[ÿd�����%�Q��g����r�;�.4ah��U/�H ��f�2Z�	c+�h�-lN�aU��S	��[�\見-ڎ&��r�t;�}QV=v�e{�<�¨�aD�X�&�`�ۗJ���*�����@/�l��!I����i���Ҏ�g4_�V�UNG1X�i�׳�\��V���l:���pm���$<���P��
).�*?�by�bR0��r���4m���d�`�B�!f+��?-sb�R?`��/{W֜��t��+�;u����T]M� 	�$��҄�'~�؎Cbǉ���{=���aKk��ݽ��^����o_����!?y�����-������c�Aת�u\���j�++����^&�j����<��)����_O�� UN��z�~�q���^���wm��{̲�;�1��"]Ə]g�}���r�߷��o��g��ް^S����}x���|ݫ��}��������*Y��?��w3p_���Ҹ0��Ur�~|ޏ��{�,��b|�"�p����u���y9T��C�yrI#�s��o��_�{��K����/��Y��a�
����ތw^�����yV��?
����!���?s������[�o��Q�����,����  �����?���4E��N`��Q �_�~�4����������h����	�~�g�~���}K���ܝ�_��� ��Kb)8G�Äɡ �ԙ;X���!�EID� RQ�8d"��P`�$$�b� �'����s����[���+��rL�O��̇��x�/�3�����R���5��RFZ޵�� Kڇ�^��&��Y^�Îfsa��{n�1	���|��ۍ��'�`t�-��h�66N}0٤��f4��]���}?/�Ѫ<Ӿ?��ߵ;<p��!�_>���@�~���@�����S��Q ���;��P��w� �~���������M���(��/%�E��������y�o�?��� ��v�^
� K�������?���?��x���G�P%����G��,���?���?
��N��	s:��%��,�u���?� ����?��Â�����D����?� ��s�m�'MA������%�O�_�?�z���W���R-Ᲊ�+����B�?#SY>����O�Wz?/�f�|w����x_�g�WƲj�~x_��S�'1�i�(�8�f%�Ԩ�y�\���r���6w׃U֠N[kdx�j�͒�\i��^�V����T�X{�Z��������Q�z��S�'�3}��`;[���譾s�u��~��GK���Fyl��h�f����7��̛l�A���8H�;��M�ߔ��fq�N��.U�jy�{����Յ(�W!���a�W'�)v3���%��p�_0��QH��?��Â����0�����X��w��h������O���O���w��0��8���� ����X��õ�-�s��(��������/������?|�������V�t�a��m�[���%����q�cX�����T������5o%��AH�p��uf��pk�;s�!耫�.�d�ᯤ|.4J9�4#�)�$i�b]��C�5P6ኌ���[��gװ��6�OdSίq�������7B���ڹ���9�'����z��a�6Fr�ӵM4It�������L����b�\5�*��c��>��2�(]�b�/uKFN̳ؐԣ�Iˮٝ[�o��� �G���?�@�M�c�]n� ���[����̋k�����H���Ð�!G��S1'r!+r$'IaB&l(�B�Q��L�̈́�D|�1�		3~8��=�����w��g��ߘ�ʲ]��-�Ȗ��ߜ��j.K%f��&��Nê���o�b�,�lg��Ѯ�������jG��*15�ʹh��h���fAK�Tk��l��c���U9���v��� ����[�����š��;�S�B����_q������0`�����9,�������!�+�3��Y���zi��B�;�3���{��F�ߟD��d��S��7��wմ]�u������Հ9�G�0wƑ�|���d'�k�Լ�S:�r�6ܕ\�7��<��=[��[vC�����c��!�[0����h�'~���P��_����������?������,X�?A���^����R������۪*�n������ap��O
��?���e�Ɉ���� ���/�  �ֳwg ��jT�΢�|W��! �� ���p�v��\.5�K�qZ.�)9�7C�]���F=7����q�NU=Et)�:ݦ���z\8���F=�Vo�f"Y��|��QN��}G���Ƿp����_�2��*Jn*�x`��zE9�OB��a`@��Z9MۉU�w-��vSO�ӜHQ��-�ie�52SM:l{d*%��Pf~���/5�J��	��"��m�л��٭*e1��O�R5e<5�� ��p�l�j�ce�H��Y�ܣ���l;_�5��]�=1O�E�{ǩ[o��2ލ8�?����X�(���@��@����������?�|<p���s���H�����[���������������������_�������� � C�I!b�N؈� x���y1a�0�L���E)a��
� �������_���w����p7=+��G�K�8��]Y=hVΎ�u�=��.m.y��u:Z�_�z��8'vb.F�'w뚸/�b1g��j<�7�I�#�5��<){�L��!���Lϣ�fo�J�_q7-��W�����a���;� ��������%�{@�������������?��!���<�q�?���O�7�?��C��/_��cT����� �?x���r�����֮��Z�c\V��e_/��̾���N��kr�T���ֈ�����cį�~_����~�y��u�A���T+>�j�wu'6�MU��5���^���A�7ᶼ6"z����i�+�:�p4�F%���3_�W�&Z�`df���>��iޘ���4e�J\�r������R����|�;A1��t�Ӽ1_��NA��!�
o��:Wc�`w[��ʦ��Y��	UOס;HX18I\O*�~I�.q=/�J{5.�F�p~9���xYY�@7rSv�v@��*+	���:2�e�Ȁ��;�=��[��?��+ ������)�_Z��Bp܀C�����?$��o����o���������R X��ϭ�p�8�/����-dp���_����������=����M��C����w���>��b�����#�O��m�� �� *��_��B� ��/��a�wQ(����` ����ԝ���H���9D� ��/���;�_��	��0�@T����,�? �?���?��K8~	X�?�&�������ΐ����X�?wS����?�� ��{�,�? �?���?������+H��9D����s�?,���^����E�����$ �� ��(6������	0��8���� ����X��õ�-���w$�����9p�����8@�?��C���:��%`���;�����ir̶�M����s�?��yq-��t���)�,C2�pHF�Ȑ�P��aĆb$�4�0ǋq@FKF%
�RBH�r�?�G]�.p��� �/_����=G@�i胧��Z;G��"P�J��%7`�)Iy��4��4��<��.�P�Ī�f����%ѩӰ�nԑ-U�;���ٞ�Y���T	T�t�su�,�IJ�ݩw�;ܑ�������8UG���\����A$�5owlj5�L�b�����ݼ��?p̀����š��;�S�B����_q������0`�����9,�������!�+�3�kG��Jۖ�WJ�Ɗؖ��D�M��S=�d�j�Gy�/����M�[g�̬S�m�\z��x���aD�nir�c]�;%�t���`u�������-�^���d�N[/&��Y��x��7��!����Q�W��?�p������ �_���_������@,���f������xM�����/�O�/���S7�����d/*�}���_%����A�]�����_�V���$���Ǭ��f�r�rI�O�5�:��*L����{c���Q�i�j3��d'c{���6&�D>���z�d�u7S~Ş�N��̬.s�V����O���w]:�R�o{%7��QR����:y"�ī�-:�k�4m'Vu�U�P�N�M=QN��E����Y���n�"��mը	��[K�9:�T���X��mP�w���y���n'��ͩߐǊ�������Ҡ�t:ۖbI�����J�n�L��Ŋ���n��/��r'��[���x��/�R�aH�!��>b�_�~����S��#�������o$������%^����<��$�?���4Iݞ����(���|=��?����/�g��!�����,WU�����aZ���Z���Τ$��Ƽ9��C�w�T4�y��P闇�˼��q�ο��tF�w�Yͯ)?�s?�R~�s�������7߾L]��>�.;���%syq-!��-鹲���c��P�����䗂:��`l�5�U)�gN['�\c֛��F��ӕ�f�G�{�v���O%wE3YrV�S�M��g��쎪��$��cB<�6KJ����z8����k�-<���˚+�@�|/kr�)�G\���keS�^���cEU�9p�LI�׋S$T'[�vZߗk6W�$�!�6�4`͚�"˜Z5YSty�У��*e�vw{�����th��9��h.��N)5Re�%wr���T���>��^�������'9-m���ܼ����M���"�'����P�X:��LD�Y>��$K�7��0XF���I(QABFT�����������?$�����嚿��q8IB��͠���d��!��aL�|%y����+_��=r�V����������}��Gq��C�%0���H������@��������?����k�.���9�gl�}���J[�-]���x�����ۻ�fE�-��_a׫x�:|ydЎ�� �y��� dRA���{���y3�*oee����^@�����>{������K@�SϾ����|��o�!��+��������7ks��{��]�~���~��}fO�R��=C\���#����❮��ڼQv\��p��N���z�Kqt\�lX5��+*�#��$u�!_������;~?Uήñ��cS*�2�D��ݱ�u<���pkOYy�>�M�ߏuf�iݛI>�Ǯ;���1c�����(Fih?t��XG��Y�Zw�ca�n��y�Mn���൦�J!Q]no�hp�{�����(��#���@�o&�`��TZ'u��Vq�bV	"]�������i���U��%{�D,�8E�N%[�j�ο�,��?����������'6hחp�-Rj��!ǚ076���V������4�7����˖T� _+[���V|��?-���?����/A�%j�V�a���@Ͽ���B��B��?o���_�!c������� +�������g��3����������c���<v��}�%T[���ۃ���7��0ns��C��♝\�>�ݎ}-��|X ��Y}$T�����N�����l�m�e[�öx�Zו+�k���+W�s��;���0��t��Ko+ᅼ��pV*��2
��؋���z�\
G��dQ�{�����z��Ǿ1=��:�p��-⁻�����r����Z��K�N�-�wJxl��/��K�G�Ͳq����~,oYk������H�ǃ�1�efj�/�u!��N�X���oJu���Ͷ�}S�U{���Jc��������pS�]u�h��`0b֪�ȪԐ�5�pd�aM�;ő0���Z�p��}j[U�?r����"�?�^�o���Y���
�Q��c�"�?��Y�?����o�?�
�g����O����OX�������pp`�?��+���~Ș��\�P����[�����	�����oP�꿃������W�w	�=d���y����������;������M�?��?���'���� /�O��y�; ��?�'���������?����s��N��?���.DNȊ��\���� �?@����(�����!�#�� )$�������_��� ���!����M������C&��P��?@�X��������������X�����
a���H���3���P��?������d�<�_�X��3��l�W�'�����LP�����P���s��C�?��?.
��0�rB��om��h`����[���+����2B!�_�	70��,)U��C/5�F�n�K�R����NҺij55�C�VØ
�����{�tx��+����������ȓ�,*5������%�m�-q��4l���o��_^�B���XM}��E�gנ��
V�N#~�b�V���$��Z'��O��uۼ=`���Q�3��8)�q�(s�q5D�z��d�txc������7�֞�{�(D4�q�«�<�V�7Or�;�����8�����{��"��P�3?�5�GX�-�0�������������>%f`ޣ�(�������ǩV����GL��!1�,�5��qǲ6�.��#q���ë��&����]M�l'�.>��8��aS���ݞ�4*:�k�㥢r"�:E�z�[)SO]k)�������(��_�oN�s���'=��o�B�A�Wn��/����/���远�?�sD!�E��?���X��Y�u?�nǊ���:0�G�!c�p�O�s�����-$����g:�[|�lC^{�XLf��v0�SFu��贷��T�&ˮ���L�#���̌��b�9��~-�d[a����: v퍺�+j_�׫a��(����ܮ͒uv	�O�J���峖����d�%�\_�?�)�s����^g����D ǉ��˛ۂRg덚��C^i>9�|"�,Ξ�gx8ޗt�}0k�Juk�m]�>g�֑[��H�Y���alr_L���c�NHM�i:���vG�t~x��E�8�������_�`��"���K�؝�����,P�g��1��Y 3�y���	���?o�'��O1�ȕ��$�������;��w����	r��WM���G�?���Oމ����LP$��*��#+������/�������P��?>.
���;�_�� w� s�����
����!7����c.(��O������	���qN�?ԏ�rT=tG�����#0��4���u�m��������z��H+����]?�~����܏4�yC��͍����k��ս��-�_q�a�ϝq���i�V�u�g��>R�{���\�\��u1Y�7ʎ��N��i�w5C})������<sE�rd_��i�����^�~�;y��&�]�cQ�aǦT�'e��Ti�ce�x����֞��|}f����_֙�uo&i�����Fƌ!׳.��,���~�Ǳ�4��������~��Q�������kM�B������$3��q�����r�����=���[���a�?7���_� S���S����L ��������_���$�������&�y�C������
��	��;G��{��?���/���z�������n�;bG�'U'J��g�j�_����K��=�9��`����5M�r ��?>� T�N�N��*a7�r]�Q��*�b�w�mY�ww�1�����U�~����nW&6J��Q���꫚��&���  i�_�@�$�?��l<`ek�ܔ��}\f�h����d�c&!Q�Űv�:���y��ۑ�c��C�U�tԎC��h���3�߉5������F!�~�������M�������������N��
�(��5���
c������j,+�F��Ѥ�S�IX�fP�nb*��&�C�*C,i�}��~�?2�����B�6���?Ĝ:�W�Z�Ϝ����GxG�W��0�-]�\��<����?O��vF�̓U��@����g4�[���֔۾UQ���T�s�!ʫ�D�Q��i]�3�4�N�S[����|+�0�C�������6��{ E�������������K���{(E����÷����~3�W�֓]bH]��t�u�a���?G}.v���j��C�D�ƣ��~�l���A�o5��G��0�fXe�hb�.OＯ�_1��������ن�ɍ7�9;z$��[Q���&��bH���@��B�Q��/������_���_������4`>(����
远�%�7M����-[��w�(Q�V�h�ü���{������r �k#��9 ��Ս@G;U�y��ˊ���i�W5}m�Ƥ���TC�hE_-�Lt���,�n���kc�L�������rg��6+�[�?�yH��8�����=߫܌��7�8�	���\��?�@�%8O$׏Z�_�J^4֔� �zĺ��3���}��bD��y���Ul�Q�Y/f�Fw�O��\n|ط����
rq��V��at|I癉t�loE+Ę=m�ũc��m,[�C���<��֡^�Z6}���9![k6V9���2�a;��������V�;��St|ۜ����D�}��I���L�ᕒF�FF������ӧ���IuF=�� *�,7����(�ﱣ�/?��u�r\tLO�����1J��/�{�
R�1���m������V_��>���Y��OZ����۪�����H.�e������ec�-]_���u�˖b>��o}�ӧ$��<�����/������O0�����㡚��pt���+�NF%#���K~�xQI�l�'�U�e���FTzg��H���"�(�� 0�#�N`��68!uy��O?���/K��Ou����;l�v�^�_��~����?���ϒ/�W�Y�����ෟ><��LH!}�/J��ۃ�O�y:���r{_�޽_z�L�3V��1�A�q�`c,-#(]�R�-=?!�a������e��Rl'��=���&����8�����(}J��;��m�;���5H?�ۻ��b��������	7�������.$y��^h�r��5z�7� {���P�|=��_N�n[�c���QXB���k:ܨ��q��+��#��b�����%%#��&�>��w�O����=A�o{|�#���Dusi�>L�����OJ��M�J/������Le�/��	}zz�y    ���Q��� � 